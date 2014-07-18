class SuperUsers::PermissionsController < SuperUsers::BaseController
  inherit_resources

  actions :index

  def root_url
    super_user_root_url
  end

  def collection_url
    super_user_permissions_url
  end

end