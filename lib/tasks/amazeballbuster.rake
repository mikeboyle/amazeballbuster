namespace :amazeballbuster do
  desc "Retweets anyone who tweets amazeballs"
  task bust: :environment do
    Twitterbot.new(search_term: "amazeballs").search_and_retweet
  end

  desc "Removes the oldest tweets from db"
  task clean_up_db: :environment do
    DbJanitor.new.clean_up_db
  end

  desc "Manage followers"
  task manage_followers: :environment do
    Twitterbot.new.manage_followers
  end

end