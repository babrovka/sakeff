class Im::DialoguesController < BaseController

  helper_method :collection,
                :d_collection,
                :resource,
                :d_resource,
                :messages,
                :d_messages

  def index
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


end