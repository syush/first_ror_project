class CommentsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_comment, only: [:show, :update, :destroy]

  def create
   # @post = Post.find(params[:post_id])
   # @comment = @post.comments.new(comment_params)
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
    end
    redirect_to @comment.post
  end

  def update
    abort_if_not_authorized(@comment)
    if @comment.update(comment_params)
      redirect_to @comment.post, notice:t('.notice')
    else
      @error_comment = @comment
      redirect_to @comment.post, alert:t('.alert')
    end
  end

  def destroy
    abort_if_not_authorized(@comment)
    @comment.destroy
    redirect_to @comment.post, notice:t('.notice')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :post_id)
    end
end
