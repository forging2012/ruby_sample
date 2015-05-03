class SessionController < ApplicationController

  def new
  end

  # 添加方法
  def create
  	# 查找用户
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# 将用户信息存到session中
  		log_in user
  		# 登录成功 重定向到用户页面
  		redirect_to user_url(user)
  	else
  		# 错误信息闪现 .now方法是在render重新渲染专用的闪现方法 可以避免闪现消息在跳转其他页面时不消失的bug
  		flash.now[:danger] = '邮箱/密码错误'
  		render 'new'
  	end
  end

  def destroy
  end

end
