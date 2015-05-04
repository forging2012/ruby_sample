module SessionHelper
	# 将用户信息写入session
	def log_in(user)
		# rails自带的存session方法
		session[:user_id] = user.id
	end

	# 获取当前登录用户信息 （如果有）
	def current_user
		# 如果session中存有用户信息
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies.signed[:remember_token])
				log_in user
				@current_user = user
			end
		end

	end

	# 判断用户是否已经登录
	def logged_in?
		!current_user.nil?
	end

	# 登出方法
	def log_out
    forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# 保存记忆令牌
	def remember(user)
		# 将记忆令牌存入数据库
		user.remember
		# 将用户Id和remember_token 加密后 存入cookie
		cookies.permanent.signed[:user_id] = user.id  #permanet是永久的意思 cookies指定时可以指定expire
		cookies.permanent.signed[:remember_token] = user.remember_token
	end

  # 忘记用户
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
