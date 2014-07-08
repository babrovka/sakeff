class SuperUsers::OrganizationsDecorator < Draper::CollectionDecorator


  private

  def decorator_class
    SuperUsers::OrganizationDecorator
  end

end