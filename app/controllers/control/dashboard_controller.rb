class Control::DashboardController < BaseController
  before_filter :authorize_dispatcher#, only: [:index]

  def index
    @eve = Control::Eve.instance
  end

  # Activates a certain status
  # @note is called when user clicks a status button on dashboard view
  def activate
    eve = Control::Eve.instance
    eve.change_global_state_to Control::State.where(system_name: params[:state]).first

    @eve = eve

    activate_notification

    respond_to do |format|
      format.js
    end
  end


  def spun
    @eve = Control::Eve.instance
  end


  private

  # Publishes information about dam objects statuses
  # @note is called on activate
  def activate_notification
    PrivatePub.publish_to "/broadcast/control", statuses: get_statuses
  end

  # Gets statuses of objects for broadcasting
  # @note is called in activate_notification
  # @return [Array of Hashes]
  def get_statuses
    [{:globalObject => {status_text: @eve.global_state.name, status_type: @eve.overall_state ? 'normal' : 'alarm'}}]
  end


  # Checks for dispatcher before allowing access
  def authorize_dispatcher
    unless current_user.has_permission?(:access_dispatcher)
      redirect_to clean_path
    end

  end

end