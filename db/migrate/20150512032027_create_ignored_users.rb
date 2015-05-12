class CreateIgnoredUsers < ActiveRecord::Migration
  def change
    create_table :ignored_users do |t|
      t.string :user_id 
      t.timestamps null: false
    end
    add_index :ignored_users, :user_id
  end
end
