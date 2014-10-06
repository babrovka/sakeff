# Contains methods for messages
class Im::OrganizationsController < BaseController

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource,
                :receiver_organization

  before_filter :check_read_permissions, only: [:show]
  before_filter :check_their_organization, only: [:show]
  before_filter :check_write_permissions, only: [:create]

  def index
  end

  def show
    @sorted_collection ||= d_collection.group_by{ |message| message.created_at.strftime('%d.%m.%Y') }
  end

  # @note publishes to "/broadcast/im/organizations" channel data that there are new messages
  #   which must be taken by ajax afterwards
  def create
    message = Im::Message.new permitted_params
    if dialogue.send message
      @message = Im::MessageDecorator.decorate message

      PrivatePub.publish_to "/broadcast/im/organizations", update_me: true

      respond_to do |format|
        format.html { redirect_to messages_organization_path(receiver_organization) }
        format.js {  }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { render nothing: true }
      end
    end
  end

  def clear_notifications
    dialogue.clear_notifications
    render json: true
  end

  private

  def collection
    @organization_messages ||= dialogue.messages
  end

  def d_collection
    @organization_messages ||= Im::MessagesDecorator.decorate collection
  end

  def resource
    @organization_message ||= Im::Message.new
  end

  def dialogue
    @dialogue ||= Im::Dialogue.new(current_user, :organization, params[:id])
  end

  def permitted_params
    params.require(:im_message).permit(:text)
  end

  def check_read_permissions
    unless current_user.has_permission?(:read_organization_messages)
      redirect_to users_root_path, error: 'У вас нет прав на просмотр диалогов между организациями'
    end
  end

  def check_write_permissions
    unless current_user.has_permission?(:send_organization_messages)
      redirect_to users_root_path, error: 'У вас нет прав на отправку сообщений между организациями'
    end
  end


  # проверка на открытие страницы диалога со своей же организацией
  # не даем пользователю открыть такую страницу
  def check_their_organization
    if params[:id] == current_organization.id
      redirect_to users_root_path, error: 'Данный диалог не доступен для вас'
    end
  end

  def receiver_organization
    Organization.where(id: params[:id]).first
  end

end