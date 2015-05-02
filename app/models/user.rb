class User < ActiveRecord::Base
	# 为了避免索引在某些数据区分大小写的问题 在存数据库时 统一将email存成小写  再存入数据库之前调用
	before_save { self.email = email.downcase }
	# 验证规则
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence:true, length: { maximum:200 }, format: { with:VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	has_secure_password
end
