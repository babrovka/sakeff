class SuperUsers::LogDecorator < Draper::Decorator
  decorates :log
  delegate_all


  def username
    username = SuperUsers::SuperUserDecorator.decorate(user).name if user.is_a? SuperUser
    username = user.username if user.is_a? User

    username
  end

  def username_with_hint
    h.content_tag :span, username, title: "UUID: #{user.uuid}"
  end

  def event_type_description
    I18n.t(object.event_type, scope: 'super_users.logs.index.table.results')
  end

  def comment
    if object.comment?
      object.comment
    else
      '-'
    end
  end

  def result
    if object.result=='Success'
      h.content_tag :span, object.result, class: 'text-green'
    else
      h.content_tag :span, object.result, class: 'text-red'
    end
  end

  private

  def user
    @user ||= SuperUser.where(uuid: object.user_id).first || User.where(id: object.user_id).first
    @user.uuid ||= @user.uuid || @user.id
    @user
  end


end
