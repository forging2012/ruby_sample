class UsersController < ApplicationController
    
  # 事前过滤器 这个过滤器表示在使用edit update方法前 要调用logged_in_user方法
  before_action :logged_in_user, only:[:edit, :update, :index]
  # 验证是否为正确的用户登录
  before_action :correct_user, only:[:edit, :update]

  def new

	@user = User.new

  end


  def index

    # 实现分页功能
    @users = User.paginate(page: params[:page], per_page: 10)

  end

  def create
  	# render text: 'cc'
  	# @user = User.new(params[:user])  如果没有指定允许传入的字段 是无法直接使用这种方式进行初始化类
  	@user = User.new(user_params)

  	 # debugger
  	if @user.save
      # 将用户信息存到session
      log_in @user
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

  def edit
    # 获取被修改用户
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 处理更新成功的情况
      flash[:success] = "更改成功"
      redirect_to @user
      else
        # 更新失败 返回编辑页面
        render 'edit'
    end
  end

  # 获取注册用户的注册信息
  private

  	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)

  	end
  
  # 确保用户已经登录过
  def logged_in_user
    # 如果没有登录过 返回错误信息 并且重定向
    unless logged_in?
      store_location
      flash[:danger] = '请登录'
      redirect_to login_path
    end
  end

  # 确保为正确的用户
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end