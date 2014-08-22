class Im::MessageDecorator < Draper::Decorator
  decorates 'im/message'
  delegate_all

  def date
    DateFormatter.new object.created_at
  end

end
