class Api::NotificationsController < Api::BaseController
  respond_to :json

  # @note respond all notifications for current user
  def index
    render json: {
        notifications:[
            { name: 'broadcast', count: 5, module: 'im'},
            { name: Organization.last.id, count: 1, module: 'im'},
            { name: Organization.first.id, count: 4, module: 'im'},
            { name: 'broadcast', count: 10, module: 'units'}
        ]
    }
  end

end
