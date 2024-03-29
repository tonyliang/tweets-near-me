require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should has a name" do
     tweet = Tweet.new
     tweet.pic = 'http://me.com/me.jpg'
     tweet.text = 'hello'
     tweet.location = [34.33,33.44]
     assert !tweet.save
  end
  
  test "should has picture" do
     tweet = Tweet.new
     tweet.text = 'hello'
     tweet.location = [34.33,33.44]
     tweet.name = 'John'
     assert !tweet.save
  end

  test "should has text" do
     tweet = Tweet.new
     tweet.pic = 'http://me.com/me.jpg'
     tweet.location = [34.33,33.44]
     tweet.name = 'John'
     assert !tweet.save
  end

  test "should has location" do
     tweet = Tweet.new
     tweet.text = 'hello'
     tweet.name = 'John'
     tweet.pic = 'http://me.com/me.jpg'
     assert !tweet.save
  end
=begin
  test "should save" do
     tweet = Tweet.new
     tweet.text = 'hello'
     tweet.name = 'John'
     tweet.pic = 'http://me.com/me.jpg'
     tweet.location = [33,44]
     assert tweet.save

  end 
=end
end
