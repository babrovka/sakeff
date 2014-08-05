class Control::DashboardController < BaseController

  def index
    @eve = Control::Eve.instance
  end
  
  # AJAX stuff 

  def activate
    eve = Control::Eve.instance
    eve.change_global_state_to Control::State.where(system_name: params[:state]).first

    @eve = eve

    respond_to do |format|
      format.js
    end
  end

  # / AJAX stuff
end
