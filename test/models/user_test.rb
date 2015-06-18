require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: 'fugen', email: '123328084@qq.com', password: '63292590', password_confirmation: '63292590')
  	
  end

  test "should be valid" do
  	assert @user.valid?
  end

  # name为必须字段
  test "should be name present" do
  	@user.name = '  '
  	assert_not @user.valid?
  end

  # email为必须字段
  test "should be email present" do
  	@user.email = '  '
  	assert_not @user.valid?
  end

  # 验证name字段的长度最长不能超过50
  test "should be name not long" do
  	@user.name = 'a' * 51
  	assert_not @user.valid?
  end

  # 验证email字段的长度不能超过200
  test "should be email not long" do
  	@user.email = 'a' * 201
  	assert_not @user.valid?
  end

  # 验证能通过email检测的格式
  test "should be accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do | valid_address |
  		@user.email = valid_address
  		assert @user.valid? "#{valid_address.inspect} should be valid"
  	end

  end

  # 验证不能通过email检测的格式
  test "should be reject invalid addresses" do
  	valid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
  	valid_addresses.each do | valid_address|
  		@user.email = valid_address
  		assert_not @user.valid? "#{valid_address.inspect} should be invalid"
  	end
  end

  # 验证email是否唯一
  test "email address should be unquie" do
  	# 由于就算是大小写不同 只要字母全相同 也算同一个地址 所以需要将大小写进行统一转化
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	# user存入之后 如果做了唯一性验证 那么duplicate_user的验证应该是无法通过
  	@user.save
  	assert_not duplicate_user.valid?

  end

  # 测试密码的最短长度是否有效
  test "password should be have a minimum" do
  	@user.password = @user.password_confirmation = 'a' * 5
  	assert_not @user.valid?
  end

  # 测试email是否会自动转化为小写
  test "email should be saved lower-case " do
  	email = 'FOAFSA@qq.com'
  	@user.email = email
  	@user.save
  	assert_equal email.downcase, @user.reload.email
  end

  # 如果用户没登录 那么使用auth验证应该返回false
  test "authenticated? invalid should be return false" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "如果用户被删除，关联微博应该被删除" do
    @user.save
    # 保存用户微博
    @user.micropost.create(content: '关联微博1')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end


end
