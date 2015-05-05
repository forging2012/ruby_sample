require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    # 使用users固件 定义再fixtures/users.yml
    @user = users(:fugeng)
  end

  test "login with invalid information" do
  	# 访问登录页面
  	get login_path
  	# 测试模板是否正确
  	assert_template 'session/new'
  	# 传送无效数据
  	post login_path, session: { email: '', password: '' }
  	# 进行无效登录后是否重新回到登录页面
  	assert_template 'session/new'
  	# 判断是否有闪现错误消息
  	assert_not flash.empty?
  	# 判断闪现消息有没有在这个生命周期内消失
  	get root_path
  	assert flash.empty?
  end

  test "login with valid information" do
    # 访问登录页面
    get login_path
    # 传送有效登录数据 由于在这里传送数据时无法哈希 而定义固件时必须存入哈希过的值 因此固件中用户密码全都约定为password
    post login_path, session:{ email: @user.email, password: 'password' }
    # 测试重定向是否正确
    assert_redirected_to @user
    # 重定向到重定向页面
    follow_redirect!
    # 检查模板是否正确
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    assert is_logged_in?
  end

  # 测试退出功能
  test "login with valid information follow by logout" do

    get login_path
    # 传送有效登录数据 由于在这里传送数据时无法哈希 而定义固件时必须存入哈希过的值 因此固件中用户密码全都约定为password
    post login_path, session:{ email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    #登出操作 
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 模拟已经登出的状态下 再次登出 正常情况下是不允许的 
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # 测试记住我功能
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # cookies 中不能通过符号来查找
    # assert_not_nil cookies['remember_token']
    # assigns 􏸅􏸆􏰤􏰌􏱇􏱈􏸮􏸯 􏸐􏱙􏳡􏰤􏱱􏱲􏰖􏲭􏱴􏰨􏶠􏰌􏲢􏲚􏰺在测试中assigns方法可以访问控制器中定义的实例方法，方法是把实例变量的符号形式传给assigns 这样就能访问user中得remember_token
    assert_equal assigns(:user).remember_token, cookies['remember_token']
  end

  # 测试没有记住我的登录功能
  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end







end
