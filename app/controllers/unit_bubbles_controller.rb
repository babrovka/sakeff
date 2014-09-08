# Contains methods for units bubbles interaction methods for users
class UnitBubblesController < BaseController

  # Creates a unit bubble
  # @note is called when dispatcher clicks 'add bubble' in unit tree modal form
  def create
    @unit = Unit.find(params[:unit_id])
    if @bubble = UnitBubble.create!(permitted_params)
      bm = Im::BroadcastMediator.new({}, view_context)
      bm.create_message_for_bubble(@bubble)
      bm.publish_messages_changes
    end

    PrivatePub.publish_to "/broadcast/unit/bubble/create", bubble: get_json_of_bubble(@bubble)
  end

  # Destroyes a unit bubble
  # @note is called from a unit tree if a dispatcher clicks 'delete' on a node bubble
  def destroy
    @bubble = UnitBubble.find(params[:id])
    @bubble.destroy

    PrivatePub.publish_to "/broadcast/unit/bubble/destroy", bubble: get_json_of_bubble(@bubble)
  end

  private

  # Converts bubble to json
  # @note same as jbuilder 'api/unit_bubbles/bubble.json.jbuilder'
  # @param bubble [Active Record]
  # @todo somehow take structure from that file
  def get_json_of_bubble(bubble)
    Jbuilder.encode do |json|
      json.id bubble.id
      json.text bubble.comment
      json.type bubble.bubble_type_i18n
      json.type_integer bubble[:bubble_type]
      json.unit_id bubble.unit_id
    end
  end

  def permitted_params
    params.require(:unit_bubble).permit(:bubble_type, :comment).merge(unit_id: @unit.id)
  end
end