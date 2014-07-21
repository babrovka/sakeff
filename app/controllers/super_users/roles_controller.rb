class SuperUsers::RolesController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]

  before_filter :numerify_params, only: [:update, :create]

  private

  def build_resource_params
    [params.fetch(:role, {}).permit(
                                    :title,
                                    :description,
                                    role_permissions_attributes: [:id, :result, :permission_id, :_destroy]
                                )]
  end

  # Converts string params of integer fields to integer
  # @note is called on role record update
  def numerify_params
    params["role"]["role_permissions_attributes"].each do |role_permission_params|
      role_permission_params.last["result"] = role_permission_params.last["result"].to_i
    end
  end


  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_roles_url
  end

end