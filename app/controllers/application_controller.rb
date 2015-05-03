class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # 引入session_help
  include SessionHelper
  def index
  	render text: 'hello world'
  end	
end
