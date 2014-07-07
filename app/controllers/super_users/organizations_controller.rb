class SuperUsers::OrganizationsController < SuperUsers::BaseController
  inherit_resources

  actions :all, except: [:show]


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

end