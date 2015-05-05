class DbJanitor

  def clean_up_db
    tweets = Tweet.all.order(tweet_id: :desc)
    if tweets.length > 1000
      puts "removing #{tweets.length - 1000} tweets..."
      tweets[999...tweets.length].each {|t| t.destroy}
      puts "...all done."
    else
      puts "Db is tidy. Nothing to clean up."
    end
  end

end
