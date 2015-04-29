require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: 'fugeng', email: '223328084@qq.com')
  	
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

end
