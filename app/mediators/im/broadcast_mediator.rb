class Im::BroadcastMediator

  include ActionController::StrongParameters

  def initialize(template=nil, context=nil, params={})
    @params = params
    @template = template
    @context = context
  end

  # публичный интерфейс для создания сообщения из бабла
  # в зависимости от type создается два разных текста
  def create_message_for_bubble(bubble, type = :create)
    message = Im::Message.new(bubble_message_params(bubble, type))
    if message.save!
      publish_messages_changes
      Im::MessageDecorator.decorate message
    end
  end

  # вебсокет сообщение об измененных сообщениях
  def publish_messages_changes
    PrivatePub.publish_to '/messages/broadcast', notifications: { count: Im::Message.count }
  end

  # рендерит js, который при исполнении у всех подписчиков добавляем сообщение
  def render_message_publishing
    h.escape_javascript c.render template: 'im/broadcasts/create.js'
  end

private


  def h
    @template
  end

  def c
    @context
  end

  # параметры для создания сообщения из бабла
  def bubble_message_params(bubble, type)
    txt = case type
            when :create then crated_bubble_message(bubble)
            when :destroy then destroyed_bubble_message(bubble)
            else ''
          end
    {
        text: txt,
        sender: h.current_user
    }
  end

  # текстовое сообщение в циркуляр про созданный бабл
  def crated_bubble_message(bubble)
    "На объекте «#{bubble.try(:unit).try(:label)}» новое событие: «#{bubble.try(:comment)}».\nСтатус: «#{I18n.t(bubble.try(:bubble_type), scope: 'enums.unit_bubble.bubble_type')}»"
  end

  # текстовое сообщение в циркуляр про удаленный бабл
  def destroyed_bubble_message(bubble)
    "Объект «#{bubble.try(:unit).try(:label)}» лишился сообщения: «#{bubble.try(:comment)}».\nСтатус: «#{I18n.t(bubble.try(:bubble_type), scope: 'enums.unit_bubble.bubble_type')}»"
  end


end