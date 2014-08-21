# Contains methods for units bubbles interaction methods for users
class UnitBubblesController < BaseController
  before_filter :authorize_dispatcher
  before_filter :set_unit , only: [:create]


  # Updates a unit bubble with provided
  # @note is called when dispatcher clicks 'update bubble' in unit tree modal form
  # @todo call web sockets here
  def update
    @bubble = UnitBubble.update!(permitted_params)
  end

  # Creates a unit bubble
  # @note is called when dispatcher clicks 'add bubble' in unit tree modal form
  # @todo call web sockets here
  def create
    @bubble = UnitBubble.create!(permitted_params)

  end

  # Destroyes a unit bubble
  # @note is called from a unit tree if a dispatcher clicks 'delete' on a node bubble
  # @todo call web sockets here
  def destroy
    @bubble = UnitBubble.find(params[:id])
    @bubble.destroy
  end

  private

  def permitted_params
    params.require(:unit_bubble).permit(:bubble_type, :comment).merge(unit_id: @unit.id)
  end

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end
end