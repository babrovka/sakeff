# Contains methods for dialogues
class Im::DialoguesController < BaseController
  include Dialogues

  before_action :check_read_permissions, only: [:index]

  helper_method :collection,
                :d_collection

  # Dialogues view
  def index
  end
end
