require 'fiber'
require 'eventmachine'

class ExploreController < ApplicationController
  def main
  end
  
  def index
    render :json => {:name => 'Tony'}
  end

  

  #------------------------------------------------
  # Using lightweight asynchronous database access.
  #------------------------------------------------
  def fetch(params)

      f = Fiber.current
      
      #-----------------------------------------------
      #  access_db runs database access (blocking i/o)
      #-----------------------------------------------
      access_db = Proc.new do

         puts 'run blocking i/o' 
         raw_geo = params[:geo]
         dist = 50
         max_tweets = 50
         geo = raw_geo.gsub(/\s+/,'').split(',')
         geo[0] = geo[0].to_f
         geo[1] = geo[1].to_f
         
         tweets_result_hash = tweets_within_n(geo,dist,max_tweets)
         #tweets_result_hash wil be sent to callback as an argument
       end
       
       #-------------------------------------------------
       #  callback is called when database access is done
       #-------------------------------------------------
       callback = Proc.new do |result|
             puts 'callback, database accessing is done'
             EventMachine.stop
             #continue Fiber
             f.resume(result)
       end
       
       #-----------------------------------------------------
       # EventMachine assigns job and callback, then return
       # back to caller, so that CPU can work on other request.
       #-----------------------------------------------------
       EventMachine.defer(access_db, callback)
       puts 'return back to main Fiber first'
       return Fiber.yield
   end

  #-----------------------------------
  # Handle query for near by Tweets
  #-----------------------------------
   def query

      EventMachine.run do

           Fiber.new{
                 result = fetch(params)        
                 if result
                     render :json => result
                 end
           }.resume
      end
   end

  
  #-----------------------------------------------------
  # Find Tweets from MongoDB w.r.t GeoCoordinates as geo
  # distance as n, and maximum number of tweets as m.
  #-----------------------------------------------------
  def tweets_within_n(geo,n,m)    

     tweets = Tweet.within_circle(location:[geo,n])
     result = {'result'=>[]}
     #if tweets.class != Array
     #   return result
     #end
     if tweets.count > 0
        (0..m-1).each do |i|
           if i+1 > tweets.count
               break
           end
           #create json object for each tweet
           tweets_hash = {}

           tweets_hash['id'] = tweets[i]['_id']
           tweets_hash['name'] = tweets[i]['name']
           tweets_hash['pic'] = tweets[i]['pic']
           tweets_hash['location'] = tweets[i]['location']
           tweets_hash['text'] = tweets[i]['text']

           result['result'] << tweets_hash
        end
     end

     return result
  end

end
