# Contains methods for messages
class Im::OrganizationsController < BaseController

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource


  def index
  end

  def show
    @sorted_collection ||= d_collection.group_by{ |message| message.created_at.strftime('%d.%m.%Y') }
  end

  def create

    message = Im::Message.new permitted_params
    if dialogue.send message
      respond_to do |format|
        format.html { redirect_to messages_organization_path }
        format.js {  }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { render nothing: true}
      end
    end
  end


  private

  def collection
    @organization_messages ||= dialogue.messages
  end

  def d_collection
    @organization_messages ||= Im::MessagesDecorator.decorate collection
  end

  def resource
    @organization_message ||= Im::Message.new
  end

  def dialogue
    @dialogue ||= Im::Dialogue.new(current_user, :organization, params[:organization_id])
  end

  def permitted_params
    params.require(:im_message).permit(:text)
  end

end