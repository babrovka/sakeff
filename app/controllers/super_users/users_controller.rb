class SuperUsers::UsersController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]

  helper_method :d_resource


  private

  
  def permitted_params
    params.permit(user: [ :username,
                          :first_name,
                          :last_name,
                          :middle_name,
                          :title,
                          :organization_id,
                          :password,
                          :password_confirmation
                  ])
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

end