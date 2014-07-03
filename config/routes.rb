Rails.application.routes.draw do
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'

  get 'dashboard' => 'users/dashboard#index'

  scope module: 'super_users' do
    scope '/superuser' do
      resources :organizations
    end
    scope '/super' do
      root 'dashboard#index', as: :super_users_root
    end
  end

end
