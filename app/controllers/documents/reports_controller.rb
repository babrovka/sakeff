class Documents::ReportsController < Documents::ResourceController
  include Documents::AccountableController

  layout 'documents/base'
  actions :all, except: [:index]

  helper_method :orders_collection_for_select

  def new
    @report = Documents::Report.new.tap do |report|
      report.build_document
      report.order_id = params[:order_id] if params[:order_id]
    end

    new!
  end

  def show
    @report = Documents::ShowDecorator.decorate(resource)
    order = Documents::Order.find(resource.order_id)
    tasks = order.tasks.order('created_at ASC')
    @tasks = Documents::Tasks::ListDecorator.decorate tasks,
                                           with: Documents::Tasks::ListShowDecorator
    show!
  end

  def create
    @report = Documents::Report.new(report_params).tap do |report|
      report.sender_organization = current_organization
      report.creator = current_user
      report.executor ||= current_user
      # TODO: Возможно ли создание акта без Распоряжения?
      if report.order_id.present?
        report.recipient_organization = report.try(:order).try(:sender_organization)
      end
    end

    super { notify }
  end

  def update
    resource.creator = current_user
    super do
      #notify
    end
  end

  private

  def orders_collection_for_select
    @orders_collection_for_select ||= Documents::Order.includes(:document)#.with_state('sent')
                                      .to_org(current_organization.id)
  end

  def report_params
    params.require(:documents_report)
      .permit(:order_id,
              document_attributes: [
                :id,
                :executor_id,
                :approver_id,
                :title,
                :body,
                {attached_documents_attributes: [:id, :_destroy]},
                {document_attached_files_attributes: [:attachment, :_destroy]}
              ]
      ).reject{|k,v| v.blank?}
  end
end
