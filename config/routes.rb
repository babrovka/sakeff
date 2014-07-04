Rails.application.routes.draw do
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'

  get 'dashboard' => 'users/dashboard#index', as: :users_root
  get 'library' => 'library#library'
  
  get '/users/:user/images/:image_type' => 'users/images#show', :as => :user_image
  

  scope module: 'super_users' do
    scope '/superuser' do
      root 'dashboard#index', as: :super_user_root
      resources :organizations, as: :super_user_organizations
    end
  end

end
