class Control::DashboardController < BaseController

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

end