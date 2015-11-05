class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  has_many :comments
  belongs_to :user
  has_many :categories_posts
  has_many :posts, through: :categories_posts
  has_many :tags_posts
  has_many :tags, through: :tags_posts
end
