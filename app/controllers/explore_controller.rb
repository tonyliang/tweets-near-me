require 'fiber'
require 'eventmachine'

class ExploreController < ApplicationController
  def main
  end
  
  def index
  end


  def query
    
    #EventMachine.run do
       #Fiber.new{
         puts '============' 
         raw_geo = params[:geo]
         dist = 500
         max_tweets = 10
         geo = raw_geo.gsub(/\s+/,'').split(',')
         geo[0] = geo[0].to_f
         geo[1] = geo[1].to_f
         
         tweets_result_hash = tweets_within_n(geo,dist,max_tweets)
         puts 'still go'
        # if tweets_result_hash
            puts 'abcd'
            #EventMachine::stop_event_loop
            render :json => tweets_result_hash
         #end   
       #}.resume
       
    #end

  end

  def tweets_within_n(geo,n,m)
     #f = Fiber.current
     puts '-----------'
     puts geo.inspect
     puts '-----------'
     tweets = Tweet.within_circle(location:[geo,n])
     result = {'result'=>[]}
     if tweets.count > 0
        (0..m-1).each do |i|
           if i+1 > tweets.count
               break
           end
           tweets_hash = {}
           tweets_hash['id'] = tweets[i]['_id']
           tweets_hash['name'] = tweets[i]['name']
           tweets_hash['pic'] = tweets[i]['pic']
           tweets_hash['location'] = tweets[i]['location']
           tweets_hash['text'] = tweets[i]['text']
           result['result'] << tweets_hash
        end
     end
     puts 'here'
     #return Fiber.yield result
     return result
  end
end
