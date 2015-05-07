# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # 由于这个方法中定义了必须要传一个user 因此预览方法必须也要传入一个User
  def account_activation
    user = User.first
        user.activation_token = User.new_token
        user.activation_token
        UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reser
  def password_reser
    UserMailer.password_reser
  end

end
