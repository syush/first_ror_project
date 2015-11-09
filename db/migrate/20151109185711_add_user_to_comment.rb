class AddUserToComment < ActiveRecord::Migration
  def change
    change_table :comments do |c|
      c.belongs_to :user
    end
  end
end
