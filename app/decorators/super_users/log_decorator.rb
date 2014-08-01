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
              Role.where(id: object.obj_id).first ||
              nil

    case  subject.class.name
      when 'Organization'
        subject.try(:short_title)
      when 'User'
        subject.try(:username)
      when 'Role'
        subject.try(:title)
      else
        object.obj_id
      end

  end

  def username_with_hint
    _username = username || 'Неизвестный пользователь'
    class_name = 'text-gray' if username.blank?
    h.content_tag :span, _username, title: "UUID: #{user.try(:uuid)}", class: class_name
  end

  def obj_id_with_hint
    _objectname = objectname || 'Неизвестный объект'
    class_name = 'text-gray' if objectname.blank?
    h.content_tag :span, _objectname, title: "UUID: #{object.try(:obj_id)}", class: class_name
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
    @user.uuid ||= @user.uuid || @user.id if @user
    @user
  end

  def obj_id_uuid
    @obj_id_uuid ||= User.where(id: object.obj_id).first || Organization.where(id: object.obj_id).first
    @obj_id_uuid
  end


end
