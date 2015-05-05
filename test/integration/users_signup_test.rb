require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
  test "valid signup information" do
  	get signup_path
  	name = 'Example User'
  	password = 'password'
  	password_confirmation = 'password'
  	email = 'user@example.com'

  	assert_difference 'User.count', 1 do
      # 提交数据后 重定向渲染模板
  		post_via_redirect users_path, user: {
					  							name: name,
					  							password_confirmation: password_confirmation,
					  							password: password,
					  							email: email }

  	end
  	assert_template 'users/show'

    assert flash
  end
end
