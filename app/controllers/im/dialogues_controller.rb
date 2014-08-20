class Im::DialoguesController < BaseController

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource,
                :messages,
                :d_messages


  def index
    respond_to do |format|
      format.html{ publish_messages_notification User.all }
      format.js { render layout: false }
    end
  end

  def show
  end

  private

  def collection
    @dialogues ||= Im::Dialogue.order('updated_at ASC')
  end

  def d_collection
    @d_dialogues ||= Im::DialoguesDecorator.decorate(collection)
  end

  def resource
    @dialogue ||= Im::Dialogue.where(id: params[:id]).includes(:messages).first
  end

  def d_resource
    @d_dialogue ||= Im::DialogueDecorator.decorate resource
  end

  def messages
    @messages ||= resource.messages.order('created_at ASC')
  end

  def d_messages
    @d_messages ||= Im::MessagesDecorator.decorate messages
  end


  def publish_messages_notification(recipients)
    recipients.each do |recipient|
      PrivatePub.publish_to "/private/messages/#{recipient.id}", unread_messages_amount: Im::Message.count
    end
  end

end