module TasksModuleHelper
  def tasks_module_path
    user_params = "user_id=#{current_user.id}"
    notification_params = "notifications=#{sakeff_notifications}"
    params = URI.encode("#{user_params}&#{notification_params}")
    "/tasks?#{params}"
    "http://localhost:3333/tasks?#{params}" if Rails.env.development?
  end

private

  def sakeff_notifications
    eve = Control::Eve.instance.overall_state ? 1 : 0
    units = UnitBubble.count
    messages = Im::Message.notifications_for(current_user).count
    docs = Documents::Document.notifications_for(current_user).count

    [eve, units, messages, docs]
  end
end