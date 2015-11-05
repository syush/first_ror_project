class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to :profile
      t.timestamps null: false
    end
  end
end
