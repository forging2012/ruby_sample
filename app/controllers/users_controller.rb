class UsersController < ApplicationController
    
  # 事前过滤器 这个过滤器表示在使用edit update方法前 要调用logged_in_user方法
  before_action :logged_in_user, only:[:edit, :update, :index, :destroy]
  # 验证是否为正确的用户登录
  before_action :correct_user, only:[:edit, :update]
  # 删除功能只能有管理员来操作
  before_action :admin_user, only:[:destroy]

  def new

	@user = User.new

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = '删除成功'
    redirect_to users_url
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
      # 发送激活邮件
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = '请检查你的邮箱'
      # 跳转到首页
      redirect_to root_url
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

  # 确保为管理员用户
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

end