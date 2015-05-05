class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.integer :tweet_id
      t.string :user_id
      t.string :user
      t.string :screen_name

      t.timestamps null: false
    end
    add_index :tweets, :tweet_id
  end
end
