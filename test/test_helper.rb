ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# 使用单元测试时不同结果 返回不同颜色
require "minitest/reporters"
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # 判断用户是否已经登录
  def is_logged_in?
  	!session[:user_id].nil?
  end

  # 登入测试用户
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'

    # 判断是否在集成测试中 指再integration文件夹下的测试文件
    if integration_test?
      post login_path session: { email: user.email, password: password, remember_me: remember_me }
    else
      # 如果不是集成测试 那么只能直接在session上设置值
      session[:user_id] = user.id
    end
  end

  # 判断是否为集成测试
  private
    def integration_test?
      defined?(post_via_redirect)
    end

end
