module TasksModuleHelper
  def tasks_module_path
    user_params = "user_id=#{current_user.id}"
    notification_params = "notifications=#{sakeff_notifications.join(',')}"
    params = URI.encode("#{user_params}&#{notification_params}")
    
    "#{domain_name}/tasks?#{params}"
  end

private

  def sakeff_notifications
    eve = Control::Eve.instance.overall_state ? 1 : 0
    units = UnitBubble.count
    messages = Im::Message.notifications_for(current_user).count
    docs = Documents::Document.notifications_for(current_user).count

    [eve, units, messages, docs]
  end


  def domain_name
    if Rails.env.development?
      'http://localhost:3333'
    else
      ''
    end
  end
end