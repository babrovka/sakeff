# coding: utf-8
module Documents
  class HistoryOrderDecorator < Documents::ShowDecorator
    decorate :order
    delegate_all

    # Hide reports that should not be seen here
    def report
      object.approved_report
    end
  end
end