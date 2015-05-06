require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:fugeng)
    @non_admin = users(:mizi)
  end

  #  分页测试
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

  # 如果非管理员用户登录 应该不显示删除链接
  test "not delete href if current_user is not admin" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'a', text: 'delete', count: 0
  end
end
