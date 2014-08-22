# == Schema Information
#
# Table name: super_users
#
#  id                     :integer          not null, primary key
#  email                  :string(32)       default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  label                  :string(32)
#  created_at             :datetime
#  updated_at             :datetime
#  uuid                   :uuid
#
# Indexes
#
#  index_super_users_on_email                 (email) UNIQUE
#  index_super_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class SuperUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :timeout_in => 10.minutes
         
  # validates :label, presence: true,
  #                   format: { with: /\A[\w\s]+\Z/ }
end
