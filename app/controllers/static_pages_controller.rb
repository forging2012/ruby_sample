class StaticPagesController < ApplicationController
  def home
  	# render text: 'hello'
    User.all
  end

  def help
  end

  def about
  end

  def contact
  end
end
