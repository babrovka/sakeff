# == Schema Information
#
# Table name: official_mails
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Documents
  class OfficialMail < ActiveRecord::Base
    include Accountable

    has_and_belongs_to_many :recipients,
                            class_name: 'Organization'

    validate :recipients_present?

    amoeba do
      clone :document
    end
    
    private

    def recipients_present?
      msg = I18n.t('activerecord.errors.models.documents.official_mail.attributes.recipient_ids.blank')
      unless recipient_organization || recipients.any?
        errors.add('recipient_ids', msg)
      end
    end
  end
end
