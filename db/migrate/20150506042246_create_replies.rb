class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :text
      t.string :tweet_id
      t.string :user_id
      t.string :user
      t.string :screen_name
      t.boolean :responded_to

      t.timestamps null: false
    end
    add_index :replies, :tweet_id
  end
end
