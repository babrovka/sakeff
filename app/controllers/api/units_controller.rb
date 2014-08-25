# Contains units api methods (json tree for example)
class Api::UnitsController < Api::BaseController
  respond_to :json

  def index
    @collection = Unit.all
  end
end
