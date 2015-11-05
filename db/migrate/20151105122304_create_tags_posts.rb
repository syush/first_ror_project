class CreateTagsPosts < ActiveRecord::Migration
  def change
    create_table :tags_posts do |t|
      t.belongs_to :tag
      t.belongs_to :post
      t.timestamps null: false
    end
  end
end
