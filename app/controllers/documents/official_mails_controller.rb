class Documents::OfficialMailsController < Documents::ResourceController
  include Documents::AccountableController

  def new
    @official_mail = Documents::OfficialMail.new.tap do |mail|
      mail.build_document
    end
    new!
  end

  def show
    show! { @official_mail = Documents::ShowDecorator.decorate(resource) }
  end

  def create
    @official_mail =
        Documents::OfficialMail.new(official_mail_params).tap do |mail|
          mail.sender_organization = current_organization
          mail.creator = current_user
          mail.executor ||= current_user
        end

    if @official_mail.recipients.any?
      ActiveRecord::Base.transaction do
        # use original record as a valuable container too
        first_recipient = @official_mail.recipients.first
        @official_mail.recipients.delete(first_recipient)
        @official_mail.recipient_organization = first_recipient

        # then duplicate all others
        @official_mail.recipients.map do |recipient|
          dup = @official_mail.amoeba_dup
          dup.recipient_organization = recipient
          dup.save!
          Documents::Accounter.sign(dup)
        end
        @official_mail.recipients.delete_all
      end
    end

    super { notify }
  end

  def update
    resource.creator = current_user
    resource.executor ||= current_user

    super { notify }
  end

  def official_mail_params
    params.require(:documents_official_mail)
      .permit(document_attributes: [
                :executor_id,
                :approver_id,
                :confidential,
                :title,
                :body,
                :id,
                {conformer_ids: []},
                {attached_documents_attributes: [:id, :_destroy]},
                {document_attached_files_attributes: [:attachment, :_destroy]}
              ], recipient_ids: [])
  end
end
