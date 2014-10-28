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
    super { notify }
  end

  def update
    resource.creator = current_user
    resource.executor ||= current_user

    super { notify }
  end

  def official_mail_params
    params.require(:documents_official_mail).permit(document_attributes: [{conformer_ids: []}, :executor_id, :approver_id, :confidential, :title, :body, :id], recipient_ids: [])
  end
end
