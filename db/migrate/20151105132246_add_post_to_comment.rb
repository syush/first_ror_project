class AddPostToComment < ActiveRecord::Migration
  def change
    change_table :comments do |c|
      c.belongs_to :post
    end
  end
end
