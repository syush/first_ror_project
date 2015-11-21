class NotificationMailer < ApplicationMailer
  def comment_notification(subscriber, post, comment)
    @post = post
    @post_owner = post.user
    @comment = comment
    @comment_owner = comment.user
    @receiver = subscriber
    if @post_owner
      mail(to: @receiver.email, subject: "Новый комментарий к публикации")
    end
  end
end
