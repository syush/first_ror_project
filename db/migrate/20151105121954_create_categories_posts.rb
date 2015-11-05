class CreateCategoriesPosts < ActiveRecord::Migration
  def change
    create_table :categories_posts do |t|
      t.belongs_to :category
      t.belongs_to :post
      t.timestamps null: false
    end
  end
end
