namespace :amazeballbuster do
  desc "Retweets anyone who tweets amazeballs"
  task bust: :environment do
    Twitterbot.new(search_term: "amazeballs").search_and_retweet
  end

  desc "Removes the oldest tweets from db"
  task clean_up_db: :environment do
    dbj = DbJanitor.new
    dbj.clean_up_db(Tweet.all)
    dbj.clean_up_db(Reply.all)
  end

  desc "Manage followers"
  task manage_followers: :environment do
    Twitterbot.new.manage_followers
  end

  desc "Respond to replies"
  task respond_to_tweets: :environment do
    Twitterbot.new(name: "amazeballbuster").respond_to_tweets
  end

end