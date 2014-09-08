# Contains methods for messages
class Im::BroadcastsController < BaseController

  before_action :check_read_permissions, only: [:show]
  before_action :check_write_permissions, only: [:create]

  after_action :websocket_after_creating_message, only: [:create]

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource

  def show
    @sorted_collection ||= d_collection.group_by{ |message| message.created_at.strftime('%d.%m.%Y') }
  end

  def create
    message = Im::Message.new permitted_params
    if message.save
      @message = Im::MessageDecorator.decorate message
      Im::SmsPresenter.send_messages(User.all, message.text)
      respond_to do |format|
        format.html { redirect_to messages_broadcast_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { render nothing: true}
      end
    end
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
    @broadcast_messages ||= Im::Message.order('created_at DESC')
  end

  def d_collection
    @broadcast_messages ||= Im::MessagesDecorator.decorate collection
  end

  def resource
    @broadcast_message ||= Im::Message.new( sender: current_user )
  end

  def permitted_params
    params.require(:im_message).permit(:text).merge({ sender_id: current_user.id, recipients: [] })
  end

  def websocket_after_creating_message
    PrivatePub.publish_to '/messages/broadcast', notifications: { count: Im::Message.count }
  end




end