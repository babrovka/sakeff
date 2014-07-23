class SuperUsers::RolesController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]

  private

  def build_resource_params
    [params.fetch(:role, {}).permit(
                                    :title,
                                    :description,
                                    role_permissions_attributes: [:id, :result, :permission_id, :_destroy]
                                )]
  end

  def root_url
    super_user_role_url
  end

  def collection_url
    super_user_roles_url
  end

end