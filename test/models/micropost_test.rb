require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup 
    @user = users(:fugeng)
    # @micropost = Micropost.new(content: '这是一个测试微博', user_id: @user.id)
    # build方法会在内存中创建一个对象而并不会添加到数据库
    @micropost = @user.micropost.build(content: '这是一个测试微博')
  end
  test "模型合法" do
    assert @micropost.valid?
  end

  test "user_id是必须的" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content是必须的" do
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  test "content最大长度为140" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test "微博是按照倒序排列的" do
    assert_equal Micropost.first, microposts(:three)
  end

end
