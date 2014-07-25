class SuperUsers::LogDecorator < Draper::Decorator
  decorates :log
  delegate_all


  def username
    username = SuperUsers::SuperUserDecorator.decorate(user).name if user.is_a? SuperUser
    username = user.username if user.is_a? User

    username
  end

  def objectname

    subject = Organization.where(id: object.obj_id).first ||
        User.where(id: object.obj_id).first ||
        object.obj_id

    if subject.is_a? Organization
      subject.short_title
    elsif subject.is_a? User
      subject.username
    else
      subject
    end

  end

  def username_with_hint
    h.content_tag :span, username, title: "UUID: #{user.uuid}"
  end
  def obj_id_with_hint
    if object.obj_id?
      h.content_tag :span, objectname, title: "UUID: #{object.obj_id}"
    else

    end
  end
  def event_type_description
    I18n.t(object.event_type, scope: 'super_users.logs.index.table.results')
  end

  def comment
    object.comment || '-'
  end

  def result
    class_name = (object.result=='Success') ? 'text-green' : 'text-red'

    if object.result=='Success'
      h.content_tag :span, object.result, class: class_name
    else
      h.content_tag :span, object.result, class: class_name
    end


  end

  private

  def user
    @user ||= SuperUser.where(uuid: object.user_id).first || User.where(id: object.user_id).first
    @user.uuid ||= @user.uuid || @user.id
    @user
  end

  def obj_id_uuid
    @obj_id_uuid ||= User.where(id: object.obj_id).first || Organization.where(id: object.obj_id).first
    @obj_id_uuid
  end


end
