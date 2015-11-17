class PostsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
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
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: 'Публикация успешно создана.'
    else
      flash.now[:alert] = 'Заголовок и тело публикации не должны быть пустыми'
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    abort_if_non_authorized(@post)
    if @post.update(post_params)
      redirect_to @post, notice: 'Публикация успешно обновлена.'
    else
      render :edit
    end
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
    params.require(:post).permit(:title, :body, :category_ids => [])
  end
end
