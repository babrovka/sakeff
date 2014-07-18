class Control::RegulationsController < BaseController
  inherit_resources
  actions :all, except: :show

  def activate
    regulation = Control::Regulation.find(params[:regulation_id])
    regulation.activated_at = Time.now
    regulation.save

    Control::ActiveRegulationFactory.construct

    redirect_to action: :index
  end

  def index
    @active_regulation = Control::ActiveRegulationFactory.get_regulation
    super
  end

  def change_state
    @active_regulation = Control::ActiveRegulationFactory.get_regulation
    @active_regulation.send("#{params['event']}!")
    redirect_to action: :index    
  end

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
