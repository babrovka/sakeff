class SuperUsers::RolesController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]
  
  private
  
  def build_resource_params
    [params.fetch(:role, {}).permit(
                                    :title,
                                    :description,
                                    permissions_attributes: [:image]
                                )]
  end


  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_roles_url
  end

end