class Im::MessagesDecorator < Draper::CollectionDecorator

  private

  def decorator_class
    Im::MessageDecorator
  end

end