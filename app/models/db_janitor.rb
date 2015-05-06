class DbJanitor

  def clean_up_db(collection)
    tweets = collection.order(tweet_id: :desc)
    if tweets.length > 5000
      puts "removing #{tweets.length - 1000} tweets..."
      tweets[999...tweets.length].each {|t| t.destroy}
      puts "...all done."
    else
      puts "Db is tidy. Nothing to clean up."
    end
  end

end
