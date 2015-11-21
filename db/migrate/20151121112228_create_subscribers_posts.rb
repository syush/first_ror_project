class CreateSubscribersPosts < ActiveRecord::Migration
  def change
    create_table :subscribers_posts do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.timestamps null: false
    end
  end
end
