Rails.application.routes.draw do

 #首页
  root 'static_pages#home'
  
  get 'static_pages/help'

  get 'static_pages/about'

  get 'static_pages/contact'



end
