# Contains methods for messages
class Im::MessagesController < BaseController
  before_action :authenticate_user!
  # before_filter :authorize_dispather, only: [:new, :create]

  def index
    @messages = current_user.inbox_messages
  end

  def new

  end

  def create

  end

  def show
    @message = Im::Message.find(params[:id])
  end
end