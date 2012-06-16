require 'test_helper'
require 'json'

class ExploreControllerTest < ActionController::TestCase

  test "should get main" do
    get :main
    assert_response :success
  end

  test "test json" do
     
      get :index,{:format=> 'json'}
      @json = {'name' => 'Tony'}
      tweet = JSON.parse(response.body)
      assert_equal @json,tweet
    
  end  

  test "should get json object from query" do

     get :query,{:geo => '19.365460180789984, -99.2624348401883'}
     json = {'result'=>[{'name' => 'Tony'}]}
     tweet = JSON.parse(response.body)
     assert_equal json['result'].class,tweet['result'].class
  end


  
end
