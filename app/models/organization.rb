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
#  deleted_at   :datetime
#
# Indexes
#
#  index_organizations_on_deleted_at  (deleted_at)
#

class Organization < ActiveRecord::Base
  include Uuidable
  acts_as_paranoid

  validates :legal_status, presence: true
  
  validates :inn, presence: true,
                  uniqueness: true,
                  numericality: true,
                  length: { is: 10 }
                  
  validates :full_title, :short_title, presence: true,
                                       format: { with: /\A[А-яЁё\w\s]+\Z/u }
                    
  

  enum legal_status: [:ip, :ooo, :zao, :oao]

end
