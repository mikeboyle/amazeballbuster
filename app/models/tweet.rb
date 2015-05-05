class Tweet < ActiveRecord::Base
  serialize :mentioned_ids, Array

  validates :tweet_id, uniqueness: :true
  validates :text, uniqueness: :true

end