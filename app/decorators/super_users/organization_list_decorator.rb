class SuperUsers::OrganizationListDecorator < Draper::Decorator
  decorates :organization
  delegate_all

  def d_legal_status
    I18n.t(object.legal_status, scope: 'activerecord.attributes.organization.legal_statuses')
  end
end
