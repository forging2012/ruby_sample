require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # deliveries这个数组是用来记录发了多少邮件 初始化时将这个清空掉是为了 确保这个测试 不会被其他跟邮件有关的测试干扰
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
  	# 请求注册页面
  	get signup_path
  	# 这段代码的意思是比较User.count 经历代码块中得操作后 值有没有变化
  	assert_no_difference 'User.count' do
  		post users_path, user: { name: '', email: '223328084@qq.com', password: '63292590', password_confirmation: '63292590' }
  	end
 	#判断模板是否正确
 	assert_template 'users/new'

  end 

  # 成功注册
  test "valid signup information with account activate" do
  	get signup_path
  	name = 'Example User'
  	password = 'password'
  	password_confirmation = 'password'
  	email = 'user222@example.com'

  	assert_difference 'User.count', 1 do
      # 提交数据后 重定向渲染模板
  		post users_path, user: {
					  							name: name,
					  							password_confirmation: password_confirmation,
					  							password: password,
					  							email: email }

  	end
    # 确认只发了一封邮件
    assert_equal 1, ActionMailer::Base.deliveries.size

    # 获取create创建的对象
    user = assigns(:user)

    # 确保处于没激活状态
    assert_not user.activated?

    # 尝试未激活登录
    log_in_as(user)
    assert_not is_logged_in?
    # 无效激活令牌
    get edit_account_activation_path('无效令牌')
    assert_not is_logged_in?
    # 正确令牌 无效邮箱
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 正确令牌
    get edit_account_activation_path(user.activation_token, email: user.email )
    # 是否用户已经处于已激活状态
    assert user.reload.activated?
    follow_redirect!
    # 是否注册激活后成功跳转
    assert_template 'users/show'
    # 是否已经处于登录状态
    assert is_logged_in?
    assert flash
  end
end
