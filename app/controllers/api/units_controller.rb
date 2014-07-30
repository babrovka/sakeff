# Contains units api methods (json tree for example)
class Api::UnitsController < Api::BaseController

  # Gets root or children units
  # @note is used in jstree
  def index
    @collection = Unit.tree_units(params[:id])
  end

end