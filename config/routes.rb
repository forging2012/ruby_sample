Rails.application.routes.draw do


 #首页
  root 'static_pages#home'
  
  # 给路由定一个别名
  get 'help' => 'static_pages#help'

  get 'about' => 'static_pages#about'

  get 'contact' => 'static_pages#contact'

  # 用户登录模块
  get 'signup' => 'users#new'

  resources :users



end
