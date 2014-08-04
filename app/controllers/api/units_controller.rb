# Contains units api methods (json tree for example)
class Api::UnitsController < Api::BaseController
  respond_to :json

  # Gets root or children units
  # @note is used in jstree
  def index
    @collection = Unit.tree_units(params[:id])
  end

  # Used for a 3d model of units
  def states
    @states = Construction.all.to_json
    respond_with @states
  end

end