class Im::Dialogue

  def initialize reach
    raise Exception "Reach '#{reach}' is not supported" if reach != :broadcast
    @reach = reach
  end

  def messages
    case @reach
      when :broadcast
        Im::Message.broadcast.order('created_at DESC')
      else
        raise RuntimeError
    end
  end

  def send message, options = {}
    # умолчания
    options.reverse_merge({force: false})

    case @reach
      when :broadcast
        message.reach = :broadcast
        options[:force] ? message.save! : message.save
      else
        raise RuntimeError
    end
  end
end