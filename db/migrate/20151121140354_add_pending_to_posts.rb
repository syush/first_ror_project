class AddPendingToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :pending, :boolean, default: false
  end
end
