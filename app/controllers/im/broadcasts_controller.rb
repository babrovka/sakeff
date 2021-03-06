# Contains methods for messages
class Im::BroadcastsController < BaseController

  before_action :check_read_permissions, only: [:show]
  before_action :check_write_permissions, only: [:create]


  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource

  def show
    @sorted_collection ||= d_collection.group_by{ |message| message.created_at.strftime('%d.%m.%Y') }
  end

  def create
    message = Im::Message.new permitted_params
    if broadcast.send message
      @message = Im::MessageDecorator.decorate message
      mediator = Im::BroadcastMediator.new(view_context, self, @message)
      mediator.publish_messages_changes
      respond_to do |format|
        format.html { redirect_to messages_broadcast_path }
        format.js {  }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { render nothing: true}
      end
    end
  end

  def clear_notifications
    broadcast.clear_notifications
    render json: true
  end

  private

  def check_read_permissions
    unless current_user.has_permission?(:read_broadcast_messages)
      redirect_to users_root_path, error: 'У вас нет прав на чтение циркулярных сообщений'
    end
  end

  def check_write_permissions
    unless current_user.has_permission?(:send_broadcast_messages)
      redirect_to users_root_path, error: 'У вас нет прав на отправку циркулярных сообщений'
    end
  end

  def collection
    @broadcast_messages ||= broadcast.messages
  end

  def d_collection
    @broadcast_messages ||= Im::MessagesDecorator.decorate collection
  end

  def resource
    @broadcast_message ||= Im::Message.new
  end

  def broadcast
    @broadcast ||= Im::Dialogue.new(current_user, :broadcast)
  end

  def permitted_params
    params.require(:im_message).permit(:text)
  end

end