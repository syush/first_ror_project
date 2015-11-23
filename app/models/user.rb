class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  has_one :profile
  has_many :posts
  has_many :comments
  has_many :subscribers_posts
  has_many :subscriptions, through: :subscribers_posts, source: :post

  def author_of?(object)
    id == object.user_id
  end

  def subscribe_to(post)
    self.subscriptions << post unless self.subscriptions.include?(post)
  end

  def unsubscribe_from(post)
    self.subscriptions.delete(post)
  end

  def subscribed_on?(post)
    self.subscriptions.include?(post)
  end
end
