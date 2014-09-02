class Api::UnitBubblesController < Api::BaseController
  respond_to :json

  # @note is used in jstree
  def index
    @collection = UnitBubble.all
  end

  # Returns JSON of all bubbles grouped by types
  # @note is called on units page in nested_units.js
  # @return [JSON] like dis!
  #   [{"08012119-8456-4edb-9208-d26a9d350064":
      # {"2":{"name":"information","count":2},
      # "1":{"name":"work","count":1},
      # "0":{"name":"facilities_accident","count":2}}
    # }]
  def nested_bubbles
    render json: UnitBubble.grouped_bubbles_for_all_units
  end
end
