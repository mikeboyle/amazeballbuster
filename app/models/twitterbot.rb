class Twitterbot

  attr_reader :client

  def initialize(options = {})
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['ABALL_CONSUMER_KEY']  
      config.consumer_secret = ENV['ABALL_CONSUMER_SECRET']
      config.access_token = ENV['ABALL_ACCESS_TOKEN']
      config.access_token_secret = ENV['ABALL_ACCESS_TOKEN_SECRET']
    end
  end

end