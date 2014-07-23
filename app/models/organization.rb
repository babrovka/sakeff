# == Schema Information
#
# Table name: organizations
#
#  id           :uuid             not null, primary key
#  legal_status :integer          not null
#  short_title  :string(32)       not null
#  full_title   :string(128)      not null
#  inn          :string(10)       not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Organization < ActiveRecord::Base
  
  validates :legal_status, :short_title, :full_title, :inn, presence: true
  validates :inn, uniqueness: true
  validates :inn, numericality: true
  validates :inn, length: { is: 10 }

  enum legal_status: [:ip, :ooo, :zao, :oao]
  
end
