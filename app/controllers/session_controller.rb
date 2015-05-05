class SessionController < ApplicationController

  def new
  end

  # 添加方法
  def create
  	# 查找用户  将用户设置为实例变量 是为了在单元测试中获取 user的虚拟属性（类属性）
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  		# 将用户信息存到session中
  		log_in @user
      # 是否选择 记住我 操作
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		# 登录成功 重定向到用户页面
  		redirect_to user_url(@user)
  	else
  		# 错误信息闪现 .now方法是在render重新渲染专用的闪现方法 可以避免闪现消息在跳转其他页面时不消失的bug
  		flash.now[:danger] = '邮箱/密码错误'
  		render 'new'
  	end
  end

  def destroy
    # 只有在用户登录的情况下才能登出
  	log_out if logged_in?
  	redirect_to root_url
  end

end
