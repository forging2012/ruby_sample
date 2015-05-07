class UserMailer < ApplicationMailer


  # 设置邮件发件人
  default from: "561981343@qq.com"

  # 激活邮件
  def account_activation(user)

    @user = user
    
    mail to: user.email, subject: '账号激活'
  end

  def password_reser
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
