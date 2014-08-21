class UsersDecorator < Draper::CollectionDecorator

  private

  def decorator_class
    UserDecorator
  end


end