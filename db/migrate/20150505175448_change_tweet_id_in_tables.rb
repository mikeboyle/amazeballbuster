class ChangeTweetIdInTables < ActiveRecord::Migration
  def change
    change_column :tweets, :tweet_id, :string
    
  end
end
