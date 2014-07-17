Rails.application.routes.draw do
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'

  get 'dashboard' => 'users/dashboard#index', as: :users_root
  get 'library' => 'library#library'

  # тянем картинку к пользователю по этому урлу
  get '/users/:user/images/:image_type' => 'users/images#show', :as => :user_image


  scope module: 'super_users' do
    scope '/superuser' do
      root 'dashboard#index', as: :super_user_root
      resources :organizations, except: [:show], as: :super_user_organizations
      resources :users, except: [:show], as: :super_user_users
      resources :roles, except: [:show], as: :super_user_roles
      resources :permissions, only: [:index], as: :super_user_permissions
    end
  end

  namespace 'control' do
    resources :regulations do
      get 'activate'
    end 
  end

end
