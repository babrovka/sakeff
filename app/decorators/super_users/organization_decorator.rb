class SuperUsers::OrganizationDecorator < Draper::Decorator
  decorates :organization
  delegate_all

  def legal_status
    I18n.t(object.legal_status, scope: 'activerecord.attributes.organization.legal_statuses')
  end
end
