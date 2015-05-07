require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:fugeng)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "账号激活", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["561981343@qq.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    # CGI::escape 是rails自动转义email地址的函数
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reser" do
    mail = UserMailer.password_reser
    assert_equal "Password reser", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["561981343@qq.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
