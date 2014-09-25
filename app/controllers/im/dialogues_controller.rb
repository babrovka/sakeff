# Contains methods for messages
class Im::DialoguesController < BaseController

  before_action :check_read_permissions, only: [:index]

  helper_method :collection
                :d_collection

  def index
    @dialog_collection = collection
  end


private

  def collection
    result_dialogues ||= [] #Im::Dialogue.new(:broadcast)
    dialogues = []
    Organization.all.each do |organization|
      dialogue = Im::Dialogue.new(:organization, current_organization.id, organization.id)
      dialogues.push (dialogue.messages.count > 0 ) ? dialogue : nil
    end
    decorated_dialogues = Im::DialogueDecorator.decorate dialogues.uniq

    result_dialogues.push(decorated_dialogues)#.uniq#.flatten!.compact!
  end

  def check_read_permissions
    unless current_user.has_permission?(:read_organization_messages)
      redirect_to users_root_path, error: 'У вас нет прав на просмотр доступных диалогов'
    end
  end


end