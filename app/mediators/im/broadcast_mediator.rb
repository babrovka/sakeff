class Im::BroadcastMediator

  include ActionController::StrongParameters

  def initialize(params={}, template=nil)
    @params = params
    @template = template
  end

  # публичный интерфейс для создания сообщения из бабла
  def create_message_for_bubble(bubble)
    message = Im::Message.new(bubble_message_params(bubble))
    message.save!
    message
  end

  # вебсокет сообщение об измененных сообщениях
  def publish_messages_changes
    PrivatePub.publish_to '/messages/broadcast', notifications: { count: Im::Message.count }
  end


private


  def h
    @template
  end

  # параметры для создания сообщения из бабла
  def bubble_message_params(bubble)
    {
        text: bubble_message(bubble),
        sender: h.current_user
    }
  end

  # текстовое сообщение в циркуляр про созданный бабл
  def bubble_message(bubble)
    "На объекте «#{bubble.try(:unit).try(:label)}» новое событие: «#{bubble.try(:comment)}».\nСтатус: «#{I18n.t(bubble.try(:bubble_type), scope: 'enums.unit_bubble.bubble_type')}»"
  end

end