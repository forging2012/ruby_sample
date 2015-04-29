require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'layout link' do
  	get root_path
  	# 判断渲染的模板是否正确
  	assert_template 'static_pages/home'
  	# 判断页面中是否有这些元素 其中这个是判断a标签中href是否匹配
  	assert_select "a[href=?]", root_path, count:2
  	assert_select "a[href=?]", help_path
  	assert_select "a[href=?]", about_path
  	assert_select "a[href=?]", contact_path
  end

end
