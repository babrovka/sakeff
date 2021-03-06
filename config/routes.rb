Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  devise_for :super_users, controllers: { sessions: 'super_users/sessions' }
  devise_for :users, controllers: {sessions: 'users/sessions'}


  root 'pages#index'
  get 'profile' => 'dashboard#profile'
  get 'dashboard' => 'dashboard#index', as: :users_root

  # тянем картинку к пользователю по этому урлу
  get '/users/:user/images/:image_type' => 'users/images#show', :as => :user_image

  resources :units, only: [:index] do
    resources :bubbles, only: [:create, :destroy], :controller => 'unit_bubbles'
  end



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
    end
  end

  namespace 'control' do

    get 'dashboard' => 'dashboard#index'

    get 'clean' => 'dashboard#clean', as: :dashboard_clean
    # TODO: try to rewrite to be like "POST /dashboard/activate"
    get 'activate' => 'dashboard#activate'

    resources :regulations do
      get 'change_state', on: :collection
    end

  end

  get 'control/dashboard', to: 'control/dashboard#index'

  match 'under_construction' => 'errors#under_construction', via: :get
  match '/500' => 'errors#error_500', via: :get
  match '/404' => 'errors#error_404', via: :get

  namespace :api do
    resources :units, only: [:index] do
      collection do
        get :states
      end
    end
    resources :unit_bubbles, only: [:index] do
      collection do
         get 'nested_bubbles_amount'
      end
    end

    scope module: :im do
      resources :dialogues, only: [:index]
      resource :broadcast, only: [:show]
    end

    namespace :im do
      resources :organizations, only: [:show]
    end

    resources :notifications, only: [:index, :new]
  end

  scope module: :im do
    scope :messages do
      resource :broadcast, only: [:show, :create], as: :messages_broadcast do
        post 'clear_notifications'
      end

      # messages between organizations
      get 'organization/:id' => 'organizations#show', as: :messages_organization
      post 'organization/:id' => 'organizations#create', as: :messages_organizations
      post 'organization/:id/clear_notifications' => 'organizations#clear_notifications', as: :message_organizations_clear
    end
    resources :dialogues, only: [:index]
  end


  # Документооборот
  get '/documents' => 'documents/documents#index', as: :documents
  namespace :documents do
    resources :documents, path:'', only: [:index, :edit, :show, :update, :destroy] do
      post 'search', on: :collection
    end

    resources :official_mails, path: 'mails', except: 'index' do
      member do
        get 'assign_state'
        get 'pdf'
      end

      resources :conformations, only: [:create]

      # Приложенные документы
      resources :attached_documents, only: [:index, :create, :destroy] do
        post 'confirm', on: :collection
      end
    end

    resources :orders, except: 'index' do
      member do
        get 'assign_state'
        get 'reject'
        post 'reject', to: :create_reject
        get 'pdf'
      end

      resources :conformations, only: [:create]

      # Приложенные документы
      resources :attached_documents, only: [:index, :create, :destroy] do
        post 'confirm', on: :collection
      end
    end

    resources :reports, except: 'index' do
      member do
        get 'assign_state'
        get 'pdf'
      end

      resources :conformations, only: [:create]

      # Приложенные документы
      resources :attached_documents, only: [:index, :create, :destroy] do
        post 'confirm', on: :collection
      end
    end

    resources :task_lists, only: [:update]
  end

  # Модуль ПРОПУСКА
  resources :permits, except: [:index] do
    get 'by_type/:type' => 'permits#index', on: :collection, as: :scope
    get 'status_change/:status' => 'permits#status_change', on: :member, as: :status_change
  end



  # особая область только тестовых роутингов
  # эти роутинги доступны только для разработчиков и тестировщиков
  # на продакшене эти роутинги не должны быть доступны
  # unless Rails.env.demo? || Rails.env.production?
    get 'library' => 'library#library'
  # end

end
