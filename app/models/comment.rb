class Comment < ActiveRecord::Base
  validates :body, :post_id, presence: true
  belongs_to :post
  belongs_to :user
  after_save :send_notifications

  def send_notifications
    post.subscribers.each do |subscriber|
      unless subscriber.id == user.id
        NotificationMailer.comment_notification(subscriber, post, self).deliver_now
      end
    end
  end
end
