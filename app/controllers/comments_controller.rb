class CommentsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def edit
    abort_if_not_authorized(@comment)
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'Комментарий успешно добавлен.'
    else
      flash[:alert] = 'Комментарий не должен быть пустым'
    end
    redirect_to @post
  end

  def update
    abort_if_not_authorized(@comment)
    if @comment.update(comment_params)
      redirect_to @comment.post, notice: 'Комментарий успешно обновлен.'
    else
      flash.now[:alert] = 'Комментарий не должен быть пустым'
      render :edit
    end
  end

  def destroy
    abort_if_not_authorized(@comment)
    @comment.destroy
    redirect_to @comment.post, notice: 'Комментарий успешно удален.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body)
    end
end
