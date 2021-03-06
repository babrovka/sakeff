class Control::DashboardController < BaseController
  before_filter :authorize_dispatcher, except: :clean

  def index
    @eve = Control::Eve.instance
  end

  def clean
  end

  # Activates a certain status
  # @note is called when user clicks a status button on dashboard view
  def activate
    eve = Control::Eve.instance

    eve.change_global_state_to Control::State.where(system_name: permitted_params[:name]).first

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
    [{:globalObject => {status_text: @eve.global_state.try(:name), status_type: @eve.overall_state ? 'normal' : 'alarm'}}]
  end


  # Checks for dispatcher before allowing access
  def authorize_dispatcher
    unless current_user.has_permission?(:access_dispatcher)
      redirect_to control_dashboard_clean_path
    end
  end

  def permitted_params
    params.fetch(:control_state, {}).permit(:name)
  end

end