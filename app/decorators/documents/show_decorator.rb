# coding: utf-8
module Documents
  class ShowDecorator < Documents::BaseDecorator
    decorate :document
    delegate :title, :accountable
    delegate :serial_number, :recipient_organization, :conformers, :conformations, :sender_organization, :recipient_organization
    delegate_all

    def title
      h.content_tag :h1, object.title
    end

    def tasks_list
      object.tasks.count
      
    end

    def task_input_disable_status(id)
      id == object.sender.id
    end
  end
end