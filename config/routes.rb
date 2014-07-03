Rails.application.routes.draw do
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'

  get 'dashboard' => 'users/dashboard#index', as: :users_root

  scope module: 'super_users' do
    scope '/superuser' do
      root 'dashboard#index', as: :super_users_root
      resources :organizations
    end
  end

end
