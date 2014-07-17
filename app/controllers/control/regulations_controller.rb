class Control::RegulationsController < BaseController
  inherit_resources
  actions :all, except: :show

  def activate
    regulation = Control::Regulation.find(params[:regulation_id])
    regulation.activated_at = Time.now
    regulation.save
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
