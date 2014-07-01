Rails.application.routes.draw do
  devise_for :super_users
  devise_for :users


  root 'dashboard#public'

  get 'dashboard' => 'dashboard#private'

  scope module: 'super_users' do
    scope '/super' do
      root 'dashboard#index', as: :super_users_root
    end
  end

end
