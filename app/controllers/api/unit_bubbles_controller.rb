class Api::UnitBubblesController < Api::BaseController
  respond_to :json

  # @note is used in jstree
  def index
    @collection = UnitBubble.all
  end

  # Returns JSON of all bubbles grouped by types
  # @note is called on units page in nested_units.js
  # @return [JSON]
  def nested_bubbles_amount
    render json: UnitBubble.grouped_bubbles_for_all_units
  end
end
