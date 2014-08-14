# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  username               :string(32)       default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  first_name             :string(32)
#  last_name              :string(32)
#  middle_name            :string(32)
#  title                  :string(64)
#  organization_id        :uuid
#  created_at             :datetime
#  updated_at             :datetime
#  menu_image             :binary
#  page_image             :binary
#  email                  :string(32)
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
         
  after_save :process_images
  
  validates :organization_id, :username, presence: true

  has_many :user_permissions
  has_many :permissions, through: :user_permissions
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_one :user_tmp_image
  belongs_to :organization
  accepts_nested_attributes_for :user_tmp_image
  
  has_and_belongs_to_many :inbox_messages,
                          class_name: "Im::Message",
                          uniq: true,
                          join_table: "message_recipients",
                          foreign_key: "user_id",
                          association_foreign_key: "message_id"
  
  def timeout_in
    (Rails.env.dev? || Rails.env.development?) ? 120.minutes : 10.minutes
  end
  
  def uuid
    self.id
  end
  
  def process_images
    # проверяем есть ли временное изображение
    if self.user_tmp_image
      menu_file = self.user_tmp_image.image.path(:menu)
      page_file = self.user_tmp_image.image.path(:page)
      # проверяем есть ли реальные файлы изображений
      if File.exists?(menu_file.to_s) && File.exists?(page_file.to_s)
        menu = File.new(menu_file).read
        page = File.new(page_file).read
        # используем update_columns вместо save чтобы не вызвать цикличность
        self.update_columns(menu_image: menu, page_image: page)
        self.user_tmp_image.destroy
      end
    end
  end
  
  
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { :value => username.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  def has_permission?(permission_title)
    p = Permission.where(title: permission_title).first  
    if p 
      case self.permission_result(p)
      when 'granted'
        true
      when 'forbidden'
        false
      else 
        false
      end
    else
      false
    end
  end
  
  def permission_result(permission)

    # ищем право по правам без ролей
    permissions_results = UserPermission.where(user_id: self.id, permission_id: permission.id)
    uniq_permissions_results = permissions_results.map do |permission|
      permission.result
    end.uniq

    direct_result = uniq_permissions_results.delete('forbidden') || uniq_permissions_results.delete('granted')

    role_result = ''

    # работаем с правами из ролей, если прямых прав нет
    if direct_result.blank?
      roles_results = self.roles.map do |role|
        RolePermission.where(role_id: role.id, permission_id: permission.id)
      end.flatten

      uniq_roles_results = roles_results.map do |permission|
        permission.result
      end.uniq


      role_result = uniq_roles_results.delete('forbidden') ||  uniq_roles_results.delete('granted')
    end

    direct_result || role_result || 'default'

  end
  
  
end
