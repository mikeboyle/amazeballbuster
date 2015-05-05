namespace :amazeballbuster do
  desc "Retweets anyone who tweets amazeballs"
  task bust: :environment do
    Twitterbot.new("amazeballs").search_and_retweet
  end
end