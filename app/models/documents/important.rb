module Documents
  class Important
    def initialize(current_user)
      @user = current_user
    end

    def count
      @count = incoming.count
    end

    # Accepts :orders, :mails, :reports in
    # symbols or strings
    def count_by_type(type = nil)
      type = type.to_s
      case type
      when 'orders' then order_count
      when 'mails' then mail_count
      when 'reports' then report_count
      else
        count
      end
    end

    def mail_count
      @mail_count ||=
          incoming.mails.count
    end

    def order_count
      @order_count ||=
          incoming.orders.count
    end

    def report_count
      @report_count ||=
          incoming.reports.count
    end

    def incoming
      Document.all
        # TODO: scoped?
        #inbox_ids = Document.inbox(@user.organization).unread_by(@user).map(&:id)
        #Document.includes(:notifications).where("notifications.user_id = ? OR documents.id IN (?)", @user.id, inbox_ids)
    end
  end
end
