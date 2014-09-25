class Im::DialoguesDecorator < Draper::CollectionDecorator

  private

  def decorator_class
    Im::DialogueDecorator
  end

end