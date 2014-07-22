class SuperUsers::UsersController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]
  
  before_action :clear_password_params, :only => [:update]
  after_action :user_created, only: :create
  after_action :user_edited, only: :update
  after_action :user_deleted, only: :destroy

  helper_method :d_resource, :d_collection


  private
  
  def clear_password_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
              params[:user].delete(:password)
              params[:user].delete(:password_confirmation)
    end
  end
  
  def build_resource_params
    [params.fetch(:user, {}).permit(
                                    :username,
                                    :first_name,
                                    :last_name,
                                    :middle_name,
                                    :title,
                                    :organization_id,
                                    :password,
                                    :password_confirmation,
                                    user_tmp_image_attributes: [:image]
                                )]
  end


  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_users_url
  end


  # отдекарированный resource
  def d_resource
    SuperUsers::UserDecorator.decorate(resource)
  end

  def d_collection
    SuperUsers::UsersDecorator.decorate(collection)
  end
  
  def user_created
    Log.create(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'user_created', result: 'Success')
  end
  
  def user_edited
    Log.create(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'user_edited', result: 'Success')
  end
  
  def user_deleted
    Log.create(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'user_deleted', result: 'Success')
  end

end