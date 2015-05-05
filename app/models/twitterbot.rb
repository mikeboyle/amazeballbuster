class Twitterbot

  attr_reader :client, :search_term, :search_results

  def initialize(options = {})
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['ABALL_CONSUMER_KEY']  
      config.consumer_secret = ENV['ABALL_CONSUMER_SECRET']
      config.access_token = ENV['ABALL_ACCESS_TOKEN']
      config.access_token_secret = ENV['ABALL_ACCESS_TOKEN_SECRET']
    end
    @search_term = options[:search_term]
    @search_results = []

  end

  def search_and_retweet
    
    find_tweets
    
    if @search_results.any?
      @search_results.reverse.each {|t| retweet_tweet(t)}
    else
      puts "no tweets found"
      return false
    end

  end

  def find_tweets
    client.search("#{@search_term} -rt", 
      lang: "en", 
      result_type: "recent",
      since_id: since_id)
    .take(100)
    .each do |tweet|
      h = tweet.to_hash
      mentions = Array.new
      t = Tweet.new(
      text: tweet.text,
      tweet_id: h[:id_str],
      user_id: h[:user][:id_str],
      user: h[:user][:name],
      screen_name: h[:user][:screen_name],
      mentioned_ids: h[:entities][:user_mentions].each {|u| mentions.push(u[:id_str])}
      )

      if tweet_valid?(t)
        @search_results.push(t) 
      else
        t.destroy
      end

    end
  end

  def retweet_tweet(tweet)
    begin
      client.retweet!(tweet.tweet_id)
      puts tweet.text
    rescue => exception
      puts exception
    end
  end

  def update(text)
    begin
      client.update(text)
    rescue => exception
      puts exception
    end
  end

  def manage_followers
    unfollow_unfollowers
    follow_followers
  end

  def follow_followers
    fans = followers
    friends = following.to_a
    fans.each do |user|
      unless friends.index(user)
        begin
          follow(user)
        rescue => exception
          puts exception
        end
        puts "followed #{user}"
      end
    end
  end

  def unfollow_unfollowers
    friends = following
    fans = followers.to_a
    friends.each do |user|
      unless fans.index(user)
        begin
          unfollow(user) 
        rescue => exception
          puts exception
        end  
        puts "unfollwed #{user}"
      end
    end
  end

  def since_id
    Tweet.all.order(tweet_id: :desc).first.tweet_id.to_i
  end

  def tweet_valid?(tweet)
    search_term_in_text?(tweet) &&
      !( five_sos_mentioned?(tweet) ) &&
      tweet.save
  end

  def search_term_in_text?(tweet)
    # because some results only have term in username
    return true if tweet.text.match(/\b#{@search_term}\b/i)
  end

  def five_sos_mentioned?(tweet)
    # because 5sos fans like to send 100s or even 1000s of tweets in a row that call the band members 'amazeballs'
    five_sos_ids = ["264107729", "403245020", "403246803", "403255314", "439125710"]

    tweet.mentioned_ids.any? {|id| five_sos_ids.index(id[:id_str])}
  end

  def followers
    client.follower_ids
  end

  def following
    client.friend_ids
  end

  def follow(user)
    client.follow(user)
  end

  def unfollow(user)
    client.unfollow(user)
  end

end