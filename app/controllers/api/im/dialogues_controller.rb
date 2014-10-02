# Contains methods for api dialogues
class Api::Im::DialoguesController < BaseController
  include Dialogues

  before_action :check_read_permissions, only: [:index]
  before_action :get_dialogues, only: [:index]

  # Returns all dialogues in JSON
  # @note uses jbuilder view
  def index
  end

  private

  # Receives dialogues data
  # @note is called on index
  def get_dialogues
    d_collection
  end
end
