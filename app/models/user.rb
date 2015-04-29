class User < ActiveRecord::Base
	# 验证规则
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence:true, length: { maximum:200 }, format: { with:VALID_EMAIL_REGEX }
end
