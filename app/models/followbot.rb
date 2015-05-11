class Followbot < Twitterbot

  def initialize(options = {})
    super
  end

  # main interface

  def manage_followers
    unfollow_unfollowers
    follow_followers
  end

  # other methods called within the interface

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

  def followers
    begin
      client.follower_ids
    rescue => error
      puts error
    rescue Twitter::Error => twe
      puts twe
    rescue Timeout::Error => te
      puts te
    end
  end

  def following
    begin
      client.friend_ids
    rescue => error
      puts error
    rescue Twitter::Error => twe
      puts twe
    rescue Timeout::Error => te
      puts te
    end
  end

  def follow(user)
    client.follow(user)
  end

  def unfollow(user)
    client.unfollow(user)
  end  

end
