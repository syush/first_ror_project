class NotificationMailer < ApplicationMailer
  def comment_notification(post, comment)
    @post = post
    @post_owner = post.user
    @comment = comment
    @comment_owner = comment.user
    if @post_owner
      mail(to: @post_owner.email, subject: "Новый комментарий к публикации")
    end
  end
end
