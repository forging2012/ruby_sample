require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:fugeng)
    @other_user = users(:mizi)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # 测试如果没有登录访问edit页面
  test "should redirect edit when not logged in" do
    # 在控制器测试中 无法像集成测试那样直接访问Url 所以必须要使用这样的方式
    get :edit, id: @user
    assert_redirected_to login_url
  end

  # 测试如果没有登录访问update 方法
  test "should redirect update when not logged in" do
    patch :update, id:@user, user: {
        name: 'mizzi',
        email: '122121421',
    }
  end

  # 测试修改非自己的资料
  test "should redirect edit when wrong user logged in" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end

  test "should redirect update when wrong user logged in" do
    log_in_as(@other_user)
    patch :update, id:@user, user:{
        name: 'mizizi',
        email: '1221232412@qq.com'
    }
    assert_redirected_to root_url
  end


  # 测试没登录访问用户列表
  test "shoule redirect index where not logged in" do
    get :index
    # 没登陆应该返回登录页面
    assert_redirected_to login_url
  end

  # 测试用户没登录访问删除方法
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  # 测试非管理员用户访问删除方法
  test "should redirect destroy when not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  # 无法修改admin属性
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    patch :update, id: @user, user:{
      admin: true
    }
    assert_not @other_user.admin?
  end
end
