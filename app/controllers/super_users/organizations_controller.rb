class SuperUsers::OrganizationsController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]

  helper_method :d_collection

  def create
    super
    Log.create!(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'organization_created', result: resource.persisted? ? "Success" : "Error" )
  end

  def update
    super
    Log.create!(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'organization_edited', result: resource.errors.empty? ? 'Success' : 'Error')
  end

  def destroy
    super
    Log.create!(scope: 'user_logs', user_id: current_super_user.uuid, obj_id: resource.id, event_type: 'organization_deleted', result: resource.destroyed? ? 'Success' : 'Error')
  end


  private
  
  def permitted_params
    params.permit(:organization => [:legal_status, :short_title, :full_title, :inn])
  end


  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_organizations_url
  end

  def d_collection
    SuperUsers::OrganizationsDecorator.decorate(collection)
  end

end