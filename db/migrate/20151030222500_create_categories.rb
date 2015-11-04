class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |cat|
      cat.string :title
      cat.timestamps 
    end
  end
end
