class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  has_many :comments
  belongs_to :user
  has_many :categories_posts
  has_many :categories, through: :categories_posts
  has_many :tags_posts
  has_many :tags, through: :tags_posts

  scope :particular_order, -> (order) {order(created_at: order)}
  scope :published, -> {where(published: true)}
  scope :unpublished, -> {where(published: false)}
  scope :authored_by, -> (user) {where(user_id: user.id)}

end
