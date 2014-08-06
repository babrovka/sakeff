class Control::RegulationsController < BaseController
  inherit_resources
  actions :all, except: :show

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
