class SuperUsers::UsersController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]
  
  before_action :clear_password_params, :only => [:update]

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

end