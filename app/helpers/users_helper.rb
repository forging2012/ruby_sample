module UsersHelper
	# 返回指定用户的 Gravatar
	# 这是一个免费服务 让用户上传图片 并将其关联到邮箱url上
	def gravatar_for(user, options = { size:80 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?"
		image_tag gravatar_url, alt: user.name, class: "gravatar"
	end
end
