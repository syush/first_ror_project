class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  has_one :profile
  has_many :posts
  has_many :comments

  def author_of?(object)
    id == object.user_id
  end
end
