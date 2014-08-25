class Api::UnitBubblesController < Api::BaseController
  respond_to :json

  # @note is used in jstree
  def index
    @collection = UnitBubble.all
  end
end
