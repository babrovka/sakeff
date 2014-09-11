class Im::BroadcastMediator

  include ActionController::StrongParameters

  def initialize(template=nil, context=nil, message=nil)
    @message = message
    @template = template
    @controller = context
  end

  # публичный интерфейс для создания сообщения из бабла
  # в зависимости от type создается два разных текста
  def create_message_for_bubble(bubble, type = :create)
    message = Im::Message.new(bubble_message_params(bubble, type))
    if message.save!
      publish_messages_changes
      @message = Im::MessageDecorator.decorate message
    end
  end

  # вебсокет сообщение об измененных сообщениях
  def publish_messages_changes
    PrivatePub.publish_to '/messages/broadcast', notifications: { count: Im::Message.notifications_for(h.current_user).count }
  end

  # рендерит js, который при исполнении у всех подписчиков добавляем сообщение
  def render_message_publishing
    h.escape_javascript c.render template: 'im/broadcasts/create.js'
  end

  def publish_sms_notification(message=nil)
    _message = message || @message
    _message = _message.text if _message.is_a?(Im::Message)
    Im::SmsPresenter.send_messages(User.all, _message)
  end
  
  def publish_email_notification(message=nil)
    _message = message || @message
    _message = _message.text if _message.is_a?(Im::Message)
    NotificationMailer.delay.notify(User.pluck(:email), _message)
  end

private


  def h
    @template
  end

  def c
    @controller
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