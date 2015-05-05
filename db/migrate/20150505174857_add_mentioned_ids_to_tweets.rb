class AddMentionedIdsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :mentioned_ids, :text
  end
end
