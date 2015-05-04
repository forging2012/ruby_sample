class User < ActiveRecord::Base
	# 为了避免索引在某些数据区分大小写的问题 在存数据库时 统一将email存成小写  再存入数据库之前调用
	before_save { self.email = email.downcase }
	attr_accessor :remember_token
	# 验证规则
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence:true, length: { maximum:200 }, format: { with:VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
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
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# 忘记用户
	def forget
		update_attribute(:remember_digest, nil)
	end

end
