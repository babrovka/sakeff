# Contains methods for messages
class Im::DialoguesController < BaseController

  before_action :check_read_permissions, only: [:index]

  helper_method :collection

  def index
  end


private

  def collection
    @dialogues ||= [Im::Dialogue.new(:broadcast)]
    organizations = Organization.all.map do |organization|
      dialogue = Im::Dialogue.new(:organization, current_organization.id, organization.id)
      (dialogue.messages.count > 0 )? dialogue : nil
    end
    @dialogues.push(organizations).flatten!.compact!
  end

  def check_read_permissions
    unless current_user.has_permission?(:read_organization_messages)
      redirect_to users_root_path, error: 'У вас нет прав на просмотр доступных диалогов'
    end
  end

end