class DashboardController < BaseController
  before_action :authenticate_user!

  def index
    @messages_count = 15

    # PrivatePub.publish_to "/broadcast/dashboard_channel", statuses: get_statuses
  end

  # private
  #
  # # Gets statuses of objects for broadcasting
  # # @note is used in dashboard index
  # # @todo make real statuses
  # # @return [Array of Hashes]
  # def get_statuses
  #   [{:spunObject => {status_text: "Атака инопланетян", status_type: "alarm"}},
  #   {:kzsObject => {status_text: "Рождение единорогов", status_type: "normal"}}]
  # end

end