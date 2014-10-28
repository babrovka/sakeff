# coding: utf-8
class Documents::OrdersController < Documents::ResourceController
  include Documents::AccountableController

  # TODO: @justvitalius why do we get Report by id in Orders controller?
  # в reports#show на 37 строке линк на данный экшн
  def reject
    @parent_order = Documents::Order.find(params[:id])

    @order = Documents::Order.new.tap do |order|
      order.approver = @parent_order.approver
      order.recipient_organization = @parent_order.sender_organization
      order.sender_organization = current_organization
      order.title = "В ответ на Акт №#{report.serial_number}"
      order.build_task_list
      order.task_list.tasks.build
    end
  end

  def create_reject
    @parent_order = Documents::Order.find(params[:id])
    @order = Documents::Order.new(order_params).tap do |order|
      order.sender_organization = current_organization
      order.creator = current_user
      order.executor ||= current_user
      order.build_task_list if order.task_list.blank?
      order.task_list.tasks.build if order.task_list.blank?
    end

    if @order.save
      story = Documents::History.new @parent_order
      story.add @order
      # @order.transition_to!(params[:transition_to], default_metadata)
    else
      render action: 'reject'
    end

  end

  def new
    @order = Documents::Order.new.tap do |order|
      order.build_document
      order.build_task_list
      order.task_list.tasks.build
    end
    new!
  end

  def show
    @order = Documents::ShowDecorator.decorate(resource)
    tasks = @order.tasks.order('created_at ASC')
    @tasks = Documents::Tasks::ListDecorator.decorate tasks,
                                           with: Documents::Tasks::ListShowDecorator

    # TODO-tagir: удали все переменные,которые не используешь во вьюхе
    @task_list = @order.task_list || @order.build_task_list
    @newtasks = @task_list.tasks
    show!
  end

  def create
    @order = Documents::Order.new(order_params).tap do |order|
      order.sender_organization = current_organization
      order.creator = current_user
      order.executor ||= current_user
      order.build_task_list if order.task_list.blank?
      order.task_list.tasks.build if order.task_list.blank?
    end
    super { notify }
  end

  def update
    resource.creator = current_user
    super { notify }
  end

  def order_params
    if params[:state].present?
      params.permit(:state)
    else
      params.require(:documents_order)
      .permit(:deadline,
              :started_at,
              :is_conformer_ids,
              task_list_attributes: [tasks_attributes: [:title, :deadline, :body]],
              document_attributes:  [
                                       :executor_id,
                                       :approver_id,
                                       :confidential,
                                       :title,
                                       :body,
                                       :id,
                                       :recipient_organization_id,
                                       {conformer_ids: []}
                                     ])
    end
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
