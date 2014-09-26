# Contains methods for messages
class Im::DialoguesController < BaseController

  before_action :check_read_permissions, only: [:index]

  helper_method :collection,
                :d_collection

  def index
  end


private

  def collection
    unless @dialogues
      @dialogues = []
      dialogues_organizations = Organization.all - [current_organization]
      dialogues_organizations.each do |organization|
        dialogue = Im::Dialogue.new(:organization, current_organization.id, organization.id)
        @dialogues.push dialogue
      end
      @dialogues.compact.flatten
    end
  end

  def d_collection
    @d_dialogues ||= Im::DialoguesDecorator.decorate collection
  end

  def check_read_permissions
    unless current_user.has_permission?(:read_organization_messages)
      redirect_to users_root_path, error: 'У вас нет прав на просмотр доступных диалогов'
    end
  end


end