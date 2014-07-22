class SuperUsers::RolesController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]

  before_filter :remove_duplicates, only: [:update, :create]

  private

  def build_resource_params
    [params.fetch(:role, {}).permit(
                                    :title,
                                    :description,
                                    role_permissions_attributes: [:id, :result, :permission_id, :_destroy]
                                )]
  end

  # Removes duplicate params with the same role_id and permission_id values
  # @note is called on role record update
  def remove_duplicates
    permission_params = params["role"]["role_permissions_attributes"]
    unless permission_params.blank?
      params_without_duplicate = permission_params.to_a.uniq{|h| h[1]["permission_id"]}
      duplicate_role_permission = (permission_params.to_a - params_without_duplicate).flatten.first
      permission_params.delete(duplicate_role_permission) if duplicate_role_permission
    end
  end

  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_roles_url
  end

end