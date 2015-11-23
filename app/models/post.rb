class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  has_many :comments
  belongs_to :user
  has_many :categories_posts
  has_many :categories, through: :categories_posts
  has_many :tags_posts
  has_many :tags, through: :tags_posts
  has_many :subscribers_posts
  has_many :subscribers, through: :subscribers_posts, source: :user

  scope :by_creation_desc, -> {order(created_at: 'desc')}
  scope :published, -> {where(published: true)}
  scope :unpublished, -> {where(published: false)}
  scope :drafts, -> {where(published: false, pending:false)}
  scope :authored_by, -> (user) {where(user_id: user.id)}
  scope :pending, -> {where(pending:true)}

  def approve_notify
    NotificationMailer.approve_notification(self).deliver_now
  end

  def discard_notify
    NotificationMailer.discard_notification(self).deliver_now
  end

  def draft?
    !self.pending && !self.published
  end

  def set_draft
    self.pending = false
    self.published = false
  end

  def set_pending
    self.pending = true
    self.published =false
  end

  def publish
    self.published = true
    self.pending = false
  end

end
