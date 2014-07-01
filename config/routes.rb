Rails.application.routes.draw do
  devise_for :super_users
  devise_for :users


  root 'super_users/dashboard#index'
  get 'dashboard' => 'super_users/dashboard#index'

  namespace 'super_users' do
    root 'dashboard#index'
  end

end
