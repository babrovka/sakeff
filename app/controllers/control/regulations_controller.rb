class Control::RegulationsController < BaseController
  inherit_resources
  actions :all, except: :show
  respond_to :js, only: [:activate, :change_state]

  def index
    @active_regulation = Control::ActiveRegulationFactory.get_regulation
    super
  end
  
  # AJAX stuff 

  def change_state
    @active_regulation = Control::ActiveRegulationFactory.get_regulation
    @active_regulation.send("#{params['event']}!")
  end

  def activate
    regulation = Control::Regulation.find(params[:regulation_id])
    regulation.activated_at = Time.now
    regulation.save

    Control::ActiveRegulationFactory.construct
    @active_regulation = Control::ActiveRegulationFactory.get_regulation
  end

  # / AJAX stuff

  private

    def root_url
      control_regulations_url
    end

    def collection_url
      control_regulations_url
    end

    def permitted_params
      params.permit(control_regulation: [:name])
    end
end
