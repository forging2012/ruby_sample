require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    # 使用users固件 定义再fixtures/users.yml
    @user = users(:michael)
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

    assert is_log_in?
  end

end
