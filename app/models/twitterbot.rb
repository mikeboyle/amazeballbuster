class Twitterbot

  attr_reader :client, :search_term, :search_results

  def initialize(search_term)
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['ABALL_CONSUMER_KEY']  
      config.consumer_secret = ENV['ABALL_CONSUMER_SECRET']
      config.access_token = ENV['ABALL_ACCESS_TOKEN']
      config.access_token_secret = ENV['ABALL_ACCESS_TOKEN_SECRET']
    end
    @search_term = search_term
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
    five_sos_ids = ["264107729", "403245020", "403246803", "403255314", "439125710"]

    tweet.mentioned_ids.any? {|id| five_sos_ids.index(id[:id_str])}
  end

  def retweet_tweet(tweet)
    begin
      client.retweet!(tweet.tweet_id)
      puts tweet.text
    rescue => exception
      puts "Oops, something went wrong!"
      puts exception
    end
  end

end