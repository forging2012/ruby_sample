require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    # 判断页面中有没有title标签 并且 标签里的内容是不是Home | Ruby on Rails Tutorial Sample App
    assert_select 'title', 'Home | Ruby on Rails Tutorial Sample App'
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select 'title', 'Help | Ruby on Rails Tutorial Sample App'
  end

  test "should get about" do
  	get :about
  	assert_response :success
  	assert_select 'title', 'About | Ruby on Rails Tutorial Sample App'
  end
end
