class Comment < ActiveRecord::Base
  validates :body, :post_id, presence: true
  belongs_to :post
  belongs_to :user
  after_save :send_notification

  def send_notification
    NotificationMailer.comment_notification(post, self).deliver_now
  end
end
