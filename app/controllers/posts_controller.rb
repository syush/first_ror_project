class PostsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish,
                                  :unpublish, :subscribe, :unsubscribe]

  # GET /posts
  def index
    @posts = Post.published.all
    @title = 'Публикации'
  end

  def unpublished
    if under_admin?
      @posts = Post.unpublished.all
    else
      @posts = Post.unpublished.authored_by(current_user).all
    end
    @title = 'Мои черновики'
    render :index
  end

  # GET /posts/1
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    abort_if_non_authorized(@post)
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.subscribers << current_user
    if params[:publish]
      @post.published = true
      notice = 'Публикация успешно размещена на сайте.'
    else
      notice = 'Черновик публикации успешно сохранен.'
    end
    @post.user = current_user
    if @post.save
      redirect_to @post, notice:notice
    else
      flash.now[:alert] = 'Заголовок и тело публикации не должны быть пустыми'
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    abort_if_non_authorized(@post)
    if params[:publish] && @post.published
      notice = 'Публикация успешно обновлена.'
    elsif params[:publish] && !@post.published
      @post.published = true
      notice = 'Публикация успешно размещена на сайте.'
    elsif params[:draft] && @post.published
      @post.published = false
      notice = 'Публикация убрана с сайта и сохранена в черновиках.'
    else
      notice = 'Черновик публикации успешно обновлен.'
    end
    if @post.update(post_params)
      redirect_to @post, notice: notice
    else
      render :edit
    end
  end

  def publish
    abort_if_non_authorized(@post)
    @post.published = true
    safe_save(@post, 'Публикация успешно размещена на сайте')
  end

  def unpublish
    abort_if_non_authorized(@post)
    @post.published = false
    safe_save(@post, 'Публикация успешно убрана из открытого доступа и помещена в черновики.')
  end

  def subscribe
    @post.subscribers << current_user unless @post.subscribers.include?(current_user)
    safe_save(@post, 'Вы успешно подписаны на комментарии к этой публикации.')
  end

  def unsubscribe
    @post.subscribers.delete(current_user)
    safe_save(@post, 'Вы успешно отписались от комментариев к этой публикации')
  end

  # DELETE /posts/1
  def destroy
    abort_if_non_authorized(@post)
    @post.destroy
    redirect_to posts_url, notice: 'Публикация успешно удалена.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

   # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :publish, :draft, :category_ids => [])
  end

end
