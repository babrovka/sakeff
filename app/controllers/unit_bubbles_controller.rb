# Contains methods for units bubbles interaction methods for users
class UnitBubblesController < BaseController
  before_filter :authorize_dispatcher
  # before_filter :set_unit


  def update
  end

  def create

  end

  # Destroyes a unit bubble
  # @note is called from a unit tree if a dispatcher clicks delete on a node bubble
  def destroy
    @bubble = UnitBubble.find(params[:id])
    @bubble.destroy
  end

  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end
end