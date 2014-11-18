class PagesController < ApplicationController

  layout 'users/sessions'

  def index
    if user_signed_in?
      path = if current_user.has_permission? :view_desktop
              users_root_path
             elsif current_user.has_permission? :access_dispatcher
               control_dashboard_path
             elsif current_user.has_permission? :read_broadcast_messages
              messages_broadcast_path
             elsif current_user.has_permission? :read_organization_messages
               dialogues_path
             elsif current_user.has_permission? :view_units
               units_path
             elsif current_user.has_permission? :view_permits
               permits_path(type: :human)
             elsif current_user.has_permission? :view_documents
               documents_path
             elsif current_user.has_permission? :view_tasks
               tasks_module_path
             end

       redirect_to path
    end
  end


end