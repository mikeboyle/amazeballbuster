class Retweetbot < Twitterbot

  attr_reader :search_term, :search_results

  def initialize(options = {})
    @search_term = options[:search_term]
    @search_results = []
    super
  end

  # main interface

  def search_and_retweet
    find_tweets
    
    if @search_results.any?
      @search_results.reverse.each {|t| retweet_tweet(t)}
    else
      puts "no tweets found"
      return false
    end
  end

  # other methods called within the interface

  def find_tweets
    client.search("#{@search_term} -rt", 
      lang: "en", 
      result_type: "recent",
      since_id: 597971123905507328)
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

  def tweet_since_id
    if Tweet.any?
      Tweet.all.order(tweet_id: :desc).first.tweet_id.to_i
    else
      return 0
    end
  end

  def tweet_valid?(tweet)
    search_term_in_text?(tweet) &&
      !( teen_idols_mentioned?(tweet) ) &&
      !( IgnoredUser.find_by(user_id: tweet.user_id)) &&
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

  def retweet_tweet(tweet)
    begin
      client.retweet!(tweet.tweet_id)
      puts tweet.text
    rescue => exception
      puts exception
    end
  end

end