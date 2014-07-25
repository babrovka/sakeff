class SuperUsers::RolesController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]
  
  def create
    super
    Log.create!(scope: 'action_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'role_created', result: resource.persisted? ? "Success" : "Error" )
  end

  def update
    super
    Log.create!(scope: 'action_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'role_edited', result: resource.errors.empty? ? 'Success' : 'Error')
  end

  def destroy
    super
    Log.create!(scope: 'action_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'role_deleted', result: resource.destroyed? ? 'Success' : 'Error')
  end

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