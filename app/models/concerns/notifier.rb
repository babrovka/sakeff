module Notifier
  extend ActiveSupport::Concern

  included do
    has_many :notifications, class_name: 'Ringbell::Notification', as: :notifiable, dependent: :destroy
    class << self; attr_reader :multiple_notifications end

    scope :with_notifications_for, -> (user) {includes(:notifications).where("notifications.user_id = '#{user.id}'")}
  end

  module ClassMethods

    def acts_as_notifier &block
      self.class_eval(&block) if block_given?
    end
    
    # Возможность установить дефолтных интересантов при объявлении класса.
    # Works as a getter w/o params
    # @param *inter Array of interesants
    #
    # @example
    #   class Foo < ActiveRecord::Base
    #      default_interesants :approver, :executor
    #   end
    def interesants *inter
      inter.any? ? @interesants = inter : @interesants
    end

    # Get all notifications for certain 
    def notifications_for user
      Ringbell::Notification.where(user_id: user.id, notifiable_type: self.to_s)
    end

    # If set, more than one notification can be created per object
    def allow_multiple_notifications
      @multiple_notifications = true 
    end

    # Defines a set of notification engines
    # Works as a getter w/o params
    def engines *engines
      engines.any? ? @engines = engines : @engines
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

      self.class.engines.each do |engine|
        engine.notify user, self, options
      end     
    end

    true
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
