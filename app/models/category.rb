class Category < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  has_many :categories_posts
  has_many :posts, through: :categories_posts
end
