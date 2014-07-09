class SuperUsers::UsersDecorator < Draper::CollectionDecorator


  private

  def decorator_class
    SuperUsers::UserDecorator
  end


end