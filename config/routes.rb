# == Route Map
#
#                                             Prefix Verb   URI Pattern                                                             Controller#Action
#                                      jasmine_rails        /specs                                                                  JasmineRails::Engine
#                             new_super_user_session GET    /super_users/sign_in(.:format)                                          super_users/sessions#new
#                                 super_user_session POST   /super_users/sign_in(.:format)                                          super_users/sessions#create
#                         destroy_super_user_session GET    /super_users/sign_out(.:format)                                         super_users/sessions#destroy
#                                super_user_password POST   /super_users/password(.:format)                                         devise/passwords#create
#                            new_super_user_password GET    /super_users/password/new(.:format)                                     devise/passwords#new
#                           edit_super_user_password GET    /super_users/password/edit(.:format)                                    devise/passwords#edit
#                                                    PATCH  /super_users/password(.:format)                                         devise/passwords#update
#                                                    PUT    /super_users/password(.:format)                                         devise/passwords#update
#                     cancel_super_user_registration GET    /super_users/cancel(.:format)                                           devise/registrations#cancel
#                            super_user_registration POST   /super_users(.:format)                                                  devise/registrations#create
#                        new_super_user_registration GET    /super_users/sign_up(.:format)                                          devise/registrations#new
#                       edit_super_user_registration GET    /super_users/edit(.:format)                                             devise/registrations#edit
#                                                    PATCH  /super_users(.:format)                                                  devise/registrations#update
#                                                    PUT    /super_users(.:format)                                                  devise/registrations#update
#                                                    DELETE /super_users(.:format)                                                  devise/registrations#destroy
#                                   new_user_session GET    /users/sign_in(.:format)                                                users/sessions#new
#                                       user_session POST   /users/sign_in(.:format)                                                users/sessions#create
#                               destroy_user_session GET    /users/sign_out(.:format)                                               users/sessions#destroy
#                                      user_password POST   /users/password(.:format)                                               devise/passwords#create
#                                  new_user_password GET    /users/password/new(.:format)                                           devise/passwords#new
#                                 edit_user_password GET    /users/password/edit(.:format)                                          devise/passwords#edit
#                                                    PATCH  /users/password(.:format)                                               devise/passwords#update
#                                                    PUT    /users/password(.:format)                                               devise/passwords#update
#                           cancel_user_registration GET    /users/cancel(.:format)                                                 devise/registrations#cancel
#                                  user_registration POST   /users(.:format)                                                        devise/registrations#create
#                              new_user_registration GET    /users/sign_up(.:format)                                                devise/registrations#new
#                             edit_user_registration GET    /users/edit(.:format)                                                   devise/registrations#edit
#                                                    PATCH  /users(.:format)                                                        devise/registrations#update
#                                                    PUT    /users(.:format)                                                        devise/registrations#update
#                                                    DELETE /users(.:format)                                                        devise/registrations#destroy
#                                               root GET    /                                                                       pages#index
#                                            profile GET    /profile(.:format)                                                      dashboard#profile
#                                         users_root GET    /dashboard(.:format)                                                    dashboard#index
#                                         user_image GET    /users/:user/images/:image_type(.:format)                               users/images#show
#                                       unit_bubbles POST   /units/:unit_id/bubbles(.:format)                                       unit_bubbles#create
#                                        unit_bubble DELETE /units/:unit_id/bubbles/:id(.:format)                                   unit_bubbles#destroy
#                                              units GET    /units(.:format)                                                        units#index
#                                    super_user_root GET    /superuser(.:format)                                                    super_users/dashboard#index
#                           super_user_organizations GET    /superuser/organizations(.:format)                                      super_users/organizations#index
#                                                    POST   /superuser/organizations(.:format)                                      super_users/organizations#create
#                        new_super_user_organization GET    /superuser/organizations/new(.:format)                                  super_users/organizations#new
#                       edit_super_user_organization GET    /superuser/organizations/:id/edit(.:format)                             super_users/organizations#edit
#                            super_user_organization PATCH  /superuser/organizations/:id(.:format)                                  super_users/organizations#update
#                                                    PUT    /superuser/organizations/:id(.:format)                                  super_users/organizations#update
#                                                    DELETE /superuser/organizations/:id(.:format)                                  super_users/organizations#destroy
#                                   super_user_users GET    /superuser/users(.:format)                                              super_users/users#index
#                                                    POST   /superuser/users(.:format)                                              super_users/users#create
#                                new_super_user_user GET    /superuser/users/new(.:format)                                          super_users/users#new
#                               edit_super_user_user GET    /superuser/users/:id/edit(.:format)                                     super_users/users#edit
#                                    super_user_user PATCH  /superuser/users/:id(.:format)                                          super_users/users#update
#                                                    PUT    /superuser/users/:id(.:format)                                          super_users/users#update
#                                                    DELETE /superuser/users/:id(.:format)                                          super_users/users#destroy
#                                   super_user_roles GET    /superuser/roles(.:format)                                              super_users/roles#index
#                                                    POST   /superuser/roles(.:format)                                              super_users/roles#create
#                                new_super_user_role GET    /superuser/roles/new(.:format)                                          super_users/roles#new
#                               edit_super_user_role GET    /superuser/roles/:id/edit(.:format)                                     super_users/roles#edit
#                                    super_user_role PATCH  /superuser/roles/:id(.:format)                                          super_users/roles#update
#                                                    PUT    /superuser/roles/:id(.:format)                                          super_users/roles#update
#                                                    DELETE /superuser/roles/:id(.:format)                                          super_users/roles#destroy
#                             super_user_permissions GET    /superuser/permissions(.:format)                                        super_users/permissions#index
#                                    super_user_logs GET    /superuser/logs(.:format)                                               super_users/logs#index
#                            upload_super_user_units GET    /superuser/units/upload(.:format)                                       super_users/units#upload
#                            import_super_user_units POST   /superuser/units/import(.:format)                                       super_users/units#import
#                                   super_user_units GET    /superuser/units(.:format)                                              super_users/units#index
#                                  control_dashboard GET    /control/dashboard(.:format)                                            control/dashboard#index
#                            control_dashboard_clean GET    /control/clean(.:format)                                                control/dashboard#clean
#                                   control_activate GET    /control/activate(.:format)                                             control/dashboard#activate
#                   change_state_control_regulations GET    /control/regulations/change_state(.:format)                             control/regulations#change_state
#                                control_regulations GET    /control/regulations(.:format)                                          control/regulations#index
#                                                    POST   /control/regulations(.:format)                                          control/regulations#create
#                             new_control_regulation GET    /control/regulations/new(.:format)                                      control/regulations#new
#                            edit_control_regulation GET    /control/regulations/:id/edit(.:format)                                 control/regulations#edit
#                                 control_regulation GET    /control/regulations/:id(.:format)                                      control/regulations#show
#                                                    PATCH  /control/regulations/:id(.:format)                                      control/regulations#update
#                                                    PUT    /control/regulations/:id(.:format)                                      control/regulations#update
#                                                    DELETE /control/regulations/:id(.:format)                                      control/regulations#destroy
#                                                    GET    /control/dashboard(.:format)                                            control/dashboard#index
#                                 under_construction GET    /under_construction(.:format)                                           errors#under_construction
#                                                    GET    /500(.:format)                                                          errors#error_500
#                                                    GET    /404(.:format)                                                          errors#error_404
#                                   states_api_units GET    /api/units/states(.:format)                                             api/units#states
#                                          api_units GET    /api/units(.:format)                                                    api/units#index
#             nested_bubbles_amount_api_unit_bubbles GET    /api/unit_bubbles/nested_bubbles_amount(.:format)                       api/unit_bubbles#nested_bubbles_amount
#                                   api_unit_bubbles GET    /api/unit_bubbles(.:format)                                             api/unit_bubbles#index
#                                      api_dialogues GET    /api/dialogues(.:format)                                                api/im/dialogues#index
#                                      api_broadcast GET    /api/broadcast(.:format)                                                api/im/broadcasts#show
#                                api_im_organization GET    /api/im/organizations/:id(.:format)                                     api/im/organizations#show
#                                  api_notifications GET    /api/notifications(.:format)                                            api/notifications#index
#                               new_api_notification GET    /api/notifications/new(.:format)                                        api/notifications#new
#             clear_notifications_messages_broadcast POST   /messages/broadcast/clear_notifications(.:format)                       im/broadcasts#clear_notifications
#                                 messages_broadcast POST   /messages/broadcast(.:format)                                           im/broadcasts#create
#                                                    GET    /messages/broadcast(.:format)                                           im/broadcasts#show
#                              messages_organization GET    /messages/organization/:id(.:format)                                    im/organizations#show
#                             messages_organizations POST   /messages/organization/:id(.:format)                                    im/organizations#create
#                        message_organizations_clear POST   /messages/organization/:id/clear_notifications(.:format)                im/organizations#clear_notifications
#                                          dialogues GET    /dialogues(.:format)                                                    im/dialogues#index
#                                          documents GET    /documents(.:format)                                                    documents/documents#index
#                         search_documents_documents POST   /documents/search(.:format)                                             documents/documents#search
#                                documents_documents GET    /documents(.:format)                                                    documents/documents#index
#                            edit_documents_document GET    /documents/:id/edit(.:format)                                           documents/documents#edit
#                                 documents_document GET    /documents/:id(.:format)                                                documents/documents#show
#                                                    PATCH  /documents/:id(.:format)                                                documents/documents#update
#                                                    PUT    /documents/:id(.:format)                                                documents/documents#update
#                                                    DELETE /documents/:id(.:format)                                                documents/documents#destroy
#               assign_state_documents_official_mail GET    /documents/mails/:id/assign_state(.:format)                             documents/official_mails#assign_state
#                        pdf_documents_official_mail GET    /documents/mails/:id/pdf(.:format)                                      documents/official_mails#pdf
#              documents_official_mail_conformations POST   /documents/mails/:official_mail_id/conformations(.:format)              documents/conformations#create
# confirm_documents_official_mail_attached_documents POST   /documents/mails/:official_mail_id/attached_documents/confirm(.:format) documents/attached_documents#confirm
#         documents_official_mail_attached_documents GET    /documents/mails/:official_mail_id/attached_documents(.:format)         documents/attached_documents#index
#                                                    POST   /documents/mails/:official_mail_id/attached_documents(.:format)         documents/attached_documents#create
#          documents_official_mail_attached_document DELETE /documents/mails/:official_mail_id/attached_documents/:id(.:format)     documents/attached_documents#destroy
#                           documents_official_mails POST   /documents/mails(.:format)                                              documents/official_mails#create
#                        new_documents_official_mail GET    /documents/mails/new(.:format)                                          documents/official_mails#new
#                       edit_documents_official_mail GET    /documents/mails/:id/edit(.:format)                                     documents/official_mails#edit
#                            documents_official_mail GET    /documents/mails/:id(.:format)                                          documents/official_mails#show
#                                                    PATCH  /documents/mails/:id(.:format)                                          documents/official_mails#update
#                                                    PUT    /documents/mails/:id(.:format)                                          documents/official_mails#update
#                                                    DELETE /documents/mails/:id(.:format)                                          documents/official_mails#destroy
#                       assign_state_documents_order GET    /documents/orders/:id/assign_state(.:format)                            documents/orders#assign_state
#                             reject_documents_order GET    /documents/orders/:id/reject(.:format)                                  documents/orders#reject
#                                                    POST   /documents/orders/:id/reject(.:format)                                  documents/orders#create_reject
#                                pdf_documents_order GET    /documents/orders/:id/pdf(.:format)                                     documents/orders#pdf
#                      documents_order_conformations POST   /documents/orders/:order_id/conformations(.:format)                     documents/conformations#create
#         confirm_documents_order_attached_documents POST   /documents/orders/:order_id/attached_documents/confirm(.:format)        documents/attached_documents#confirm
#                 documents_order_attached_documents GET    /documents/orders/:order_id/attached_documents(.:format)                documents/attached_documents#index
#                                                    POST   /documents/orders/:order_id/attached_documents(.:format)                documents/attached_documents#create
#                  documents_order_attached_document DELETE /documents/orders/:order_id/attached_documents/:id(.:format)            documents/attached_documents#destroy
#                                   documents_orders POST   /documents/orders(.:format)                                             documents/orders#create
#                                new_documents_order GET    /documents/orders/new(.:format)                                         documents/orders#new
#                               edit_documents_order GET    /documents/orders/:id/edit(.:format)                                    documents/orders#edit
#                                    documents_order GET    /documents/orders/:id(.:format)                                         documents/orders#show
#                                                    PATCH  /documents/orders/:id(.:format)                                         documents/orders#update
#                                                    PUT    /documents/orders/:id(.:format)                                         documents/orders#update
#                                                    DELETE /documents/orders/:id(.:format)                                         documents/orders#destroy
#                      assign_state_documents_report GET    /documents/reports/:id/assign_state(.:format)                           documents/reports#assign_state
#                               pdf_documents_report GET    /documents/reports/:id/pdf(.:format)                                    documents/reports#pdf
#                     documents_report_conformations POST   /documents/reports/:report_id/conformations(.:format)                   documents/conformations#create
#        confirm_documents_report_attached_documents POST   /documents/reports/:report_id/attached_documents/confirm(.:format)      documents/attached_documents#confirm
#                documents_report_attached_documents GET    /documents/reports/:report_id/attached_documents(.:format)              documents/attached_documents#index
#                                                    POST   /documents/reports/:report_id/attached_documents(.:format)              documents/attached_documents#create
#                 documents_report_attached_document DELETE /documents/reports/:report_id/attached_documents/:id(.:format)          documents/attached_documents#destroy
#                                  documents_reports POST   /documents/reports(.:format)                                            documents/reports#create
#                               new_documents_report GET    /documents/reports/new(.:format)                                        documents/reports#new
#                              edit_documents_report GET    /documents/reports/:id/edit(.:format)                                   documents/reports#edit
#                                   documents_report GET    /documents/reports/:id(.:format)                                        documents/reports#show
#                                                    PATCH  /documents/reports/:id(.:format)                                        documents/reports#update
#                                                    PUT    /documents/reports/:id(.:format)                                        documents/reports#update
#                                                    DELETE /documents/reports/:id(.:format)                                        documents/reports#destroy
#                                documents_task_list PATCH  /documents/task_lists/:id(.:format)                                     documents/task_lists#update
#                                                    PUT    /documents/task_lists/:id(.:format)                                     documents/task_lists#update
#                              permits_scope_permits GET    /permits/by_type/:type(.:format)                                        permits#index
#                        permit_status_change_permit GET    /permits/:id/status_change/:status(.:format)                            permits#status_change
#                                            permits POST   /permits(.:format)                                                      permits#create
#                                         new_permit GET    /permits/new(.:format)                                                  permits#new
#                                        edit_permit GET    /permits/:id/edit(.:format)                                             permits#edit
#                                             permit GET    /permits/:id(.:format)                                                  permits#show
#                                                    PATCH  /permits/:id(.:format)                                                  permits#update
#                                                    PUT    /permits/:id(.:format)                                                  permits#update
#                                                    DELETE /permits/:id(.:format)                                                  permits#destroy
#                                            library GET    /library(.:format)                                                      library#library
#
# Routes for JasmineRails::Engine:
#   root GET  /           jasmine_rails/spec_runner#index
#

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
