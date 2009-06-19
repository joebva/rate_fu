require File.dirname(__FILE__) + '/test_helper.rb'
require 'ratings_controller'
require 'action_controller/test_process'

class RatingsController
  def rescue_action(e)
    raise e
  end
end

class RatingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = RatingsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    
    ActionController::Routing::Routes.draw do |map|
      map.rate 'ratings', :controller => 'ratings',  :action => 'rate', :method => 'post'
    end
  end
    
  
    def test_rating_route
      assert_recognition :post, "/ratings", {:controller  => "ratings", :action => "rate", :method => 'post'}
    end

    private

    def assert_recognition(method, path, options)
      result = ActionController::Routing::Routes.recognize_path(path, :method => method)
      assert_equal options, result
    end
    
    
  end
  