class PostsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :send_for_moderation,
                                  :unpublish, :subscribe, :unsubscribe, :approve, :discard]
  before_action :abort_if_not_admin!, only:[:discard, :approve]

  # GET /posts
  def index
    @posts = Post.published.by_creation_desc.all
    @title = 'Публикации'
  end

  def drafts
    @posts = Post.drafts.by_creation_desc
    @posts = @posts.authored_by(current_user) unless under_admin?
    @posts = @posts.all
    @title = 'Черновики'
    render :index
  end

  def pending
    @posts = Post.pending.by_creation_desc
    @posts = @posts.authored_by(current_user) unless under_admin?
    @posts = @posts.all
    @title = "Публикации в ожидании модерации"
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
    abort_if_not_authorized(@post)
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.subscribers << current_user
    if params[:send_for_moderation]
      @post.set_pending
      notice = 'Публикация отправлена на модерацию.'
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
    abort_if_not_authorized(@post)
    if params[:send_for_moderation]
      @post.set_pending
      notice = 'Измененная публикация станет доступна другим пользователям после модерации.'
    elsif params[:unpublish] && !@post.draft?
      @post.set_draft
      notice = 'Публикация сохранена в черновиках и не будет доступна другим пользователям.'
    else
      notice = 'Черновик публикации успешно обновлен.'
    end
    if @post.update(post_params)
      redirect_to @post, notice: notice
    else
      render :edit
    end
  end

  def send_for_moderation
    abort_if_not_authorized(@post)
    @post.set_pending
    safe_save(@post, 'Публикация станет доступна другим пользователям после модерации.')
  end

  def unpublish
    abort_if_not_authorized(@post)
    @post.set_draft
    safe_save(@post, 'Публикация помещена в черновики и недоступна другим пользователям.')
  end

  def subscribe
    current_user.subscribe_to(@post)
    safe_save(@post, 'Вы успешно подписаны на комментарии к этой публикации.')
  end

  def unsubscribe
    current_user.unsubscribe_from(@post)
    safe_save(@post, 'Вы успешно отписались от комментариев к этой публикации')
  end

  def approve
    @post.publish
    safe_save(@post, 'Теперь публикация стала доступна пользователям.') { @post.approve_notify }
  end

  def discard
    @post.set_draft
    safe_save(@post, 'Публикация отклонена.') { @post.discard_notify }
  end

  # DELETE /posts/1
  def destroy
    abort_if_not_authorized(@post)
    @post.destroy
    redirect_to :back, notice: 'Публикация успешно удалена.'
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
