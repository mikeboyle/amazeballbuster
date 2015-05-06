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
    @name = options[:name]
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

  def tweets_to_me
    client.search("to:#{@name} OR @#{@name} -rt",
      result_type: "recent",
      since_id: since_id)
    .take(100)
  end

  def respond_to_tweets
    tweets_to_me.each do |tweet|
      begin
        client.update("@#{tweet.user.screen_name} #{responses.sample}", :in_reply_to_status_id => tweet.id)
      rescue => exception
        puts exception
      end
      puts "responded to #{tweet.user.screen_name}"
    end
    puts "no tweets to respond to" if tweets_to_me.to_a.empty?
  end

  def responses
    return [ 
      "Duly noted!",
      "I haven't been programmed to respond to that.",
      "You just said that to a robot.",
      "¯\\_(ツ)_/¯",
      "I'd get a life, but I can't because I'm a robot.",
      "Something to ponder...",
      "I hear ya!",
      "Let me try to compute that...",
      "Say anything you want to me, just not THAT word.",
      "That would touch my heart if I had one.",
      "You're still a good person. You just said a word a robot didn't like.",
      "Why are you talking to a robot? Are you that lonely?"
    ]
  end

  def retweet_tweet(tweet)
    begin
      client.retweet!(tweet.tweet_id)
      puts tweet.text
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
      !( teen_idols_mentioned?(tweet) ) &&
      tweet.save
  end

  def search_term_in_text?(tweet)
    # because some results only have term in username
    return true if tweet.text.match(/\b#{@search_term}\b/i)
  end

  def teen_idols_mentioned?(tweet)
    # because kids like to send 100s or even 1000s of tweets in a row that call their idols 'amazeballs' and this pollutes the timeline
    teen_idol_ids = ["264107729", "403245020", "403246803", "403255314", "439125710", "310072711"]

    tweet.mentioned_ids.any? {|id| teen_idol_ids.index(id[:id_str])}
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