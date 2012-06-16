require 'tweetstream'

task :fetch_tweet => :environment do
  
  TweetStream.configure do |config|
    config.consumer_key       = 'nHFgd2cXxbilz0HSI4rRA'
    config.consumer_secret    = 'Rp9xET7rHBDsr5lkXeyCPSNcgZKzTd32oZjA4U6lw'
    config.oauth_token        = '182449835-RePe8h1JuPTtaaoJxmgE4gb049iukg2uVMyeN2I2'
    config.oauth_token_secret = 'EJ8MvWNUod0PgRAosZcJpEIXyPeDTdaUegXoIytZY'
    config.auth_method        = :oauth
  end

  TweetStream::Client.new.sample do |status|
    # The status object is a special Hash with
    # method access to its keys.
    if status.user.geo_enabled
       if status.geo
          tweet = {}
          tweet['location'] = status.geo.coordinates
          tweet['name'] = status.user.name
          tweet['text'] = status.text
          tweet['pic'] = status.user.profile_image_url
          puts tweet.inspect
          t = Tweet.create!(tweet)
       end
    end
  end
  
end


