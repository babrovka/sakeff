class Documents::OfficialMailsController < Documents::ResourceController
  include Documents::AccountableController

  helper_method :history

  def new
    @official_mail = Documents::OfficialMail.new.tap do |mail|
      mail.build_document
    end
    new!
  end

   # TODO: @prikha Move to another controller
  def reply
    @parent_mail = end_of_association_chain.find(params[:id])

    authorize!(:reply_to, @parent_mail)

    @official_mail = end_of_association_chain.new.tap do |mail|
      mail.build_document.tap do |doc|
        doc.recipient_organization = @parent_mail.sender_organization
      end
    end
  end

  def create_reply
    @parent_mail = end_of_association_chain.find(params[:id])

    authorize!(:reply_to, @parent_mail)

    attributes = official_mail_params
    @official_mail =
        Documents::OfficialMail.new(attributes).tap do |mail|
          mail.sender_organization = current_organization
          mail.creator = current_user
          mail.executor ||= current_user
          mail.recipient_organization = @parent_mail.sender_organization
        end
    if @official_mail.save
        story = Documents::History.new(@parent_mail)
        story.add @official_mail
        # @official_mail.transition_to!(params[:transition_to], default_metadata)
        redirect_to documents_path, notice: 'Документ успешно создан'
    else
      render action: 'reply'
    end
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
    super
  end

  def update
    resource.creator = current_user
    resource.executor ||= current_user
    super
  end

  def official_mail_params
    params.require(:documents_official_mail).permit(document_attributes: [:executor_id, :approver_id, :confidential, :title, :body, :id], recipient_ids: [])
  end

  private

  def history
    @history ||=
        Documents::ListDecorator.decorate history_scope,
                                          with: Documents::ListShowDecorator
  end

  def history_scope
    story = Documents::History.new(resource)
    story.fetch_documents_for current_organization
  end
end
