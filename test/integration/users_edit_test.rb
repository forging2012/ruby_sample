require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:fugeng)
  end

  # 更新不成功测试
  test "unsuccessful test" do
    # 用户登录
    log_in_as(@user)
    # 进入编辑更新页面
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {
        name: '',
        email: '1234563332@qq.com',
        password: 'ahahahahaha',
        password_confirmation: ''
    }
    assert_template 'users/edit'
  end

  # 更新成功测试 并且实现友好条状
  test "successful test with friendly forward" do
    # 友好跳转 即登录后访问原本登录前想访问的url
    get edit_user_path(@user)
    log_in_as(@user)
    # 这个时候应该跳转到原本想访问的地址 即edit_user_path
    assert_redirected_to edit_user_path(@user)
    name = 'miziz'
    email = 'fugeng123@gmail.com'
    patch user_path(@user), user: {
      name: name,
      email: email,
      password: '',
      password_confirmation: ''
    }
    # 测试闪现消息是否正常
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email

  end



end
