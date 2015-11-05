class AddUserToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |p|
      p.belongs_to :user
    end
  end
end
