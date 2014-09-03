# Contains methods for messages
class Im::BroadcastsController < BaseController

  # before_action :check_read_permissions, only: [:show]
  # before_action :check_write_permissions, only: [:create]

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource

  def show
    @sorted_collection ||= d_collection.group_by{ |message| message.created_at.strftime('%d.%m.%Y') }
  end

  def create
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





end