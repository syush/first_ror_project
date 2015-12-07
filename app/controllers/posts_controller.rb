class PostsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :send_for_moderation,
                                  :unpublish, :subscribe, :unsubscribe]

  # GET /posts
  def index
    @posts = Post.published.by_creation_desc.all
    @title = t('.title')
  end

  def drafts
    @posts = Post.drafts.by_creation_desc
    @posts = @posts.authored_by(current_user) unless under_admin?
    @posts = @posts.all
    @title = t('.title')
    render :index
  end

  def pending
    @posts = Post.pending.by_creation_desc
    @posts = @posts.authored_by(current_user) unless under_admin?
    @posts = @posts.all
    @title = t('.title')
    render :index
  end

  # GET /posts/1
  def show
    @comment = Comment.new
    @comment.post_id = @post.id
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
      notice = t('.notice_pending')
    else
      notice = t('.notice_draft')
    end
    @post.user = current_user
    if @post.save
      redirect_to @post, notice:notice
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    abort_if_not_authorized(@post)
    if params[:send_for_moderation]
      @post.set_pending
      notice = t('.notice_pending')
    elsif params[:unpublish] && !@post.draft?
      @post.set_draft
      notice = t('.notice_draft')
    else
      notice = t('.notice_draft_update')
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
    safe_save(@post, t('.notice'))
  end

  def unpublish
    abort_if_not_authorized(@post)
    @post.set_draft
    safe_save(@post, t('.notice'))
  end

  def subscribe
    current_user.subscribe_to(@post)
    safe_save(@post, t('.notice'))
  end

  def unsubscribe
    current_user.unsubscribe_from(@post)
    safe_save(@post, t('.notice'))
  end

   # DELETE /posts/1
  def destroy
    abort_if_not_authorized(@post)
    @post.destroy
    redirect_to :back, notice: t('.notice')
  end

  private



   # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :publish, :draft, :category_ids => [])
  end

end
