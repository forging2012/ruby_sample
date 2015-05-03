class UsersController < ApplicationController
  def new

	@user = User.new

  end

  def create
  	# render text: 'cc'
  	# @user = User.new(params[:user])  如果没有指定允许传入的字段 是无法直接使用这种方式进行初始化类
  	@user = User.new(user_params)

  	 # debugger
  	if @user.save
  		# 重定向到用户详情页
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end


  def show
  	@user = User.find(params[:id])
  end

  # 获取注册用户的注册信息
  private

  	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)

  	end
  
end