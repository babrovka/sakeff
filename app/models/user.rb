class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
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
  
  def permission_result(permission)
    # ищем право по правам из ролей
    results = []
    self.roles.each do |role|
      results << RolePermission.where(role_id: role.id, permission_id: permission)
    end
    # ищем право по правам
    results << UserPermission.where(user_id: self.id, permission_id: permission)
    
    uniq_results = results.flatten.uniq

    if uniq_results.include?('forbidden')
      'forbidden'
    elsif uniq_results.include?('granted')
      'granted'
    else
      'default'
    end
  end
  
  
end
