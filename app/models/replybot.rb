class Replybot < Twitterbot

  attr_reader :name, :replies

  def initialize(options = {})
    @name = options[:name]
    @replies = []
    super
  end

  # main interface
  def respond_to_tweets
    tweets_to_me

    if @replies.any?
      @replies.each do |reply|
        begin
          client.update("@#{reply.screen_name} #{responses.sample}", :in_reply_to_status_id => reply.tweet_id)
        rescue => exception
          puts exception
        end
        reply.responded_to = true
        reply.save
        puts "responded to #{reply.screen_name}"
      end
    end  
    puts "no tweets to respond to" if @replies.empty?
  end

  # other methods called within the interface
  def tweets_to_me
    # replies = []
    client.search("to:#{@name} OR @#{@name} -rt",
      result_type: "recent",
      since_id: reply_since_id)
    .take(100)
    .each do |reply|
      h = reply.to_hash
      r = Reply.new(
        text: reply.text,
        tweet_id: h[:id_str],
        user_id: h[:user][:id_str],
        user: h[:user][:name],
        screen_name: h[:user][:screen_name]
        )
      if r.save &&
        !(r.responded_to) && 
        (r.user_id != "2620177980") # don't respond to bot's own tweets
          @replies.push(r)
      else
        r.destroy
      end
    end
  end

  def reply_since_id
    if Reply.any?
      Reply.all.order(tweet_id: :desc).first.tweet_id.to_i
    else
      return 0
    end
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
      "Why are you talking to a robot? Are you that lonely?",
      "I'd say I was sorry, but I'm just a bot.",
      "Beep bloop bleep don't say am***balls",
      "Hmm, tell me more about that!",
      "Really? Why is that?"
    ]
  end  

end