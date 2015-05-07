class User < ActiveRecord::Base
	# 为了避免索引在某些数据区分大小写的问题 在存数据库时 统一将email存成小写  再存入数据库之前调用
	before_save :downcase_email
	# 新建对象之前 为user对象分配一个激活令牌
	before_create :create_activation_digest 
	attr_accessor :remember_token, :activation_token
	# 验证规则
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence:true, length: { maximum:200 }, format: { with:VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }, allow_blank: true # 允许修改时跳过密码的长度认证
	has_secure_password

	# 返回指定字符串的哈希摘要
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# 返回记忆令牌
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# 实现持久会话 将会话信息存入数据库
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(self.remember_token))
	end

	# 如果指定的令牌和摘要匹配 返回ture
	def authenticated?(attribute, token)
		# send方法会返回这个对象本身的方法返回值 如user.length 相当于 user.send('length') 由于再User模型内所以self.send可以简写为send
		digest = send("#{ attribute }_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# 忘记用户
	def forget
		update_attribute(:remember_digest, nil)
	end

	# 将邮箱地址转化为为小写
	def downcase_email
		self.email = email.downcase
	end

	# 为用户对象分配激活令牌
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end
