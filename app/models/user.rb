class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
  
  # after_create :process_images

  attr_accessor :username
  
  has_one :user_tmp_image
  accepts_nested_attributes_for :user_tmp_image
  
  
  # def process_images
  #   self.menu_image = File.new(File.join(self.user_tmp_image.image.path(:menu))).read
  #   self.page_image = File.new(File.join(self.user_tmp_image.image.path(:page))).read
  #   self.user_tmp_image.destroy
  # end
  
  
  
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
  
end
