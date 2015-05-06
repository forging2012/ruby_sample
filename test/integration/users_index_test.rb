require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:fugeng)
  end

  test "index including paginate" do
    # 用户登录
    log_in_as(@user)
    # 用户列表
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 10).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end

  end

end
