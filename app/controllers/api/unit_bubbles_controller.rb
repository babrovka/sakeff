class Api::UnitBubblesController < Api::BaseController
  respond_to :json

  # Gets root or children units
  # @note is used in jstree
  def index
    @collection = UnitBubble.where(unit_id: params[:id]).group_by(&:bubble_type)
  end

end