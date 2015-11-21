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

  def approve_notification(post)
    @post = post
    @post_owner = post.user
    @receiver = @post_owner
    if @post_owner
      mail(to: @receiver.email, subject: "Публикация одобрена модератором")
    end
  end

  def discard_notification(post)
    @post = post
    @post_owner = post.user
    @receiver = @post_owner
    if @post_owner
      mail(to: @receiver.email, subject: "Публикация отклонена модератором")
    end
  end

end
