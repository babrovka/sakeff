# Contains methods for units bubbles interaction methods for users
class UnitBubblesController < BaseController

  before_filter :check_bubble_permission, only: [:create, :destroy]

  respond_to :js

  # Creates a unit bubble
  # @note is called when dispatcher clicks 'add bubble' in unit tree modal form
  def create
    @unit = Unit.find(params[:unit_id])
    @bubble = UnitBubble.create(permitted_params)
    unless Rails.env.test?
      if @bubble.persisted?
        mediator = Im::BroadcastMediator.new(view_context, self)
        @message = mediator.create_message_for_bubble(@bubble, :create)
        mediator.publish_messages_changes

        PrivatePub.publish_to "/broadcast/unit/bubble/create", bubble: get_json_of_bubble(@bubble)
        PrivatePub.publish_to "/broadcast/unit/bubble/change", bubbles: UnitBubble.count
      end
    end

  end

  # Destroyes a unit bubble
  # @note is called from a unit tree if a dispatcher clicks 'delete' on a node bubble
  def destroy
    @bubble = UnitBubble.find(params[:id])
    @bubble.destroy
    unless Rails.env.test?
      mediator = Im::BroadcastMediator.new(view_context, self)
      @message = mediator.create_message_for_bubble(@bubble, :destroy)
      mediator.publish_messages_changes

      PrivatePub.publish_to "/broadcast/unit/bubble/destroy", bubble: get_json_of_bubble(@bubble)
      PrivatePub.publish_to "/broadcast/unit/bubble/change", bubbles: UnitBubble.count
    end
  end

  private

  # Checks if user can create/destroy bubbles
  # @note is called before create/destroy actions
  def check_bubble_permission
    unless current_user.has_permission?(:manage_unit_status)
      redirect_to users_root_path, error: 'У вас нет прав на взаимодействие со статусами объектов'
    end
  end

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