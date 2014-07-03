class SuperUsers::OrganizationsController < InheritedResources::Base
  
  
  
  def permitted_params
    params.permit(:organization => [:legal_status, :short_title, :full_title, :inn])
  end

end