class Api::NotificationsController < Api::BaseController
  respond_to :json

  # @note respond all notifications for current user
  def index
    notifications = []
    notifications << { name: 'broadcast', count: Im::Dialogue.new(current_user, :broadcast).unread_messages.count, module: 'messages' }
    notifications << { name: 'broadcast', count: UnitBubble.count, module: 'units' }
    (Organization.all - [current_user.organization]).each do |organization|
      notifications << { name: organization.id, count: Im::Dialogue.new(current_user, :organization, organization.id).unread_messages.count, module: 'messages' }
    end

    render json: { notifications: notifications }
  end

end
