Rails.application.routes.draw do
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'

  # тянем картинку к пользователю по этому урлу
  get '/users/:user/images/:image_type' => 'users/images#show', :as => :user_image

  resources :units, only: [:index] do
    resources :bubbles, only: [:update, :create, :destroy], :controller => 'unit_bubbles'
  end

  get 'dashboard' => 'dashboard#index', as: :users_root
  get 'profile' => 'dashboard#profile'

  scope module: 'super_users' do
    scope '/superuser' do
      root 'dashboard#index', as: :super_user_root
      resources :organizations, except: [:show], as: :super_user_organizations
      resources :users, except: [:show], as: :super_user_users
      resources :roles, except: [:show], as: :super_user_roles
      resources :permissions, only: [:index], as: :super_user_permissions
      resources :logs,  only: [:index], as: :super_user_logs
      resources :units, only: [:index], as: :super_user_units do
        get 'upload', on: :collection
        post 'import', on: :collection
      end
      # get '/units/upload' => 'units#upload', as: :super_user_units_upload
      # post '/units/import' => 'units#import', as: :super_user_units_import
    end
  end

  namespace 'control' do

    get 'dashboard' => 'dashboard#index'

    # TODO: try to rewrite to be like "POST /dashboard/activate"
    get 'activate' => 'dashboard#activate'

    resources :regulations do
      get 'change_state', on: :collection
    end

  end


  match 'under_construction' => 'errors#under_construction', via: :get

  namespace :api do
    resources :units, only: [:index] do
      collection do
        get :states
      end
    end
    resources :unit_bubbles, only: [:index] do 
      collection do
        get :grouped_bubbles_for_all_units, as: :grouped_bubbles_for_all_units
      end
    end

    scope module: :im do
      resources :messages, only: [:index, :new, :create, :show] do
        collection do
          get :user_messages
        end
      end
    end
  end

  scope module: :im do
    resources :messages
    resources :dialogues, except: [:destroy] do
      resources :messages, only: [:index] do
        collection do
          get :unread, format: 'js'
        end
      end
    end
  end

  # особая область только тестовых роутингов
  # эти роутинги доступны только для разработчиков и тестировщиков
  # на продакшене эти роутинги не должны быть доступны
  # unless Rails.env.demo? || Rails.env.production?
    get 'library' => 'library#library'
    get '/websockets_test' => 'testing#websockets', as: :websockets_test
  # end

end
