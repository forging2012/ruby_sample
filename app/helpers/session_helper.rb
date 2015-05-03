module SessionHelper
	# 将用户信息写入session
	def log_in(user)
		# rails自带的存session方法
		session[:user_id] = user.id
	end

	# 获取当前登录用户信息 （如果有）
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# 判断用户是否已经登录
	def logged_in?
		!current_user.nil?
	end
end
