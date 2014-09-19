module Notifier
  extend ActiveSupport::Concern

  included do
    has_many :notifications, class_name: 'Ringbell::Notification', as: :notifiable, dependent: :destroy
    class << self; attr_accessor :interesants, :multiple_notifications end # Class-level instance variable для хранения интересантов

    scope :with_notifications_for, -> (user) {includes(:notifications).where("notifications.user_id = '#{user.id}'")}
  end

  module ClassMethods
    
    # Возможность установить дефолтных интересантов при объявлении класса методом interesants.
    # Без параметров возвращает текущий список интересантов. При посылке нотификакий этот список можно будет изменить.
    #
    # @param inter список интересантов
    #
    # @example
    #   class Foo < ActiveRecord::Base
    #      interesants :approver, :executor
    #   end
    def default_interesants *inter
      if inter.count
        self.interesants = inter
      else
        return self.interesants
      end
    end

    def notifications_for user
      Ringbell::Notification.where(user_id: user.id, notifiable_type: self.to_s)
    end

    def allow_multiple_notifications
      self.multiple_notifications = true 
    end
  end

  # Посылаем уведомления
  # @param options
  #   - @param only [Array] каким типам интересантов посылать. По-умолчанию установлены те, которые задаются методом interesants
  #   - @param except [Array] каким типам интересантов не посылать. По-умолчанию: []
  #   - @param exclude [Array] of [User] каким пользователям не посылать. По-умолчанию: []
  # @example
  #   obj.notify_interesants only: [:approver], exclude: current_user # Посылаем уведомление только контрольному лицу, если контрольное лицо не текущий юзер
  #   obj.notify_interesants except: [:creator], exclude: doc.creator # Посылаем уведомление согласующим, исполнителю и контрольному лицу; если кто-то из них создатель - ему не посылаем
  # @see User
  def notify_interesants options = {}
    # Options defaults
    options.reverse_merge! only: self.class.interesants, except: [], exclude: [], message: '', changer: nil
    
    # Оборачиваем параметры в массивы, если переданы просто символами
    options.each {|k, option| options[k] = [option] unless option.class == Array}

    # Убираем те типы, которые не нужны
    options[:only].reject! {|type| options[:except].include? type}

    # Наполняем массив объектами типа User
    interested = types_to_users options[:only]

    interested.reject! {|user| options[:exclude].include? user} # Не отправляем уведомления тем, кто в списке exclude
    
    interested.each do |user|
      if self.class.multiple_notifications # разрешены множественные нотификации?
        self.notifications.create(user: user, message: options[:message])#, changer: options[:changer]) # создаем новую нотификацию в любом случае
      else
        self.notifications.find_or_create_by(user_id: user.id) # Создаем нотификацию, если ее еще нет
      end
    end 
  end

  # Возвращает массив объектов [User], которые являются интересантами данного объекта
  def interesants
    types_to_users self.class.interesants
  end

  # Удаляем нотификацию о текущем объекте для всех пользователей (или конкретного пользователя)
  # @param options
  #   - @param for [User] Для какого пользователя удалить
  # @example
  #   obj.clear_notifications # для всех
  #   obj.clear_notifications for: current_user # только для текущего пользователя
  # @see User
  def clear_notifications options = {}
    (options[:for] ? self.notifications.where(user_id: options[:for].id) : self.notifications).destroy_all
  end

  # Есть ли у объекта нотификация для конкретного пользователя?
  # @param user [User] Пользователь
  # @example
  #   obj.has_notifications_for? current_user
  # @see User
  def has_notification_for? user
    self.notifications.where(user_id: user.id).count > 0 ? true : false
  end

  # Количество нотификаций для конкретного пользователя
  # @param user [User] Пользователь
  # @example
  #   obj.notifications_count_for current_user
  # @see User
  def notifications_count_for user
    self.notifications.where(user_id: user.id).count
  end

private
  
  # Делает из массива списка интересантов список интересантов
  # (т.е. из [:executors, :approver] - [User, User, User])
  def types_to_users list
    interested = []

    list.each do |in_sym| 
      obj = self.send(in_sym)
      if obj.is_a? Array
        obj.each { |elem| interested << elem if elem.instance_of? User }
      else
        interested << obj if obj.instance_of? User
      end
    end

    return interested.compact.uniq
  end
end
