module Im::BroadcastsHelper

  def messages_title_grouped_by(date)
    txt = if Date.parse(date) == Date.today
            'Сегодня'
          elsif Date.parse(date) == Date.yesterday
            'Вчера'
          else
            DateFormatter.new Date.parse(date)
          end
    txt
  end

  def messages_date_is_today(date)
    Date.parse(date) == Date.today
  end

  def css_messages_date_is_today(date)
    "m-#{messages_date_is_today date}"
  end

end