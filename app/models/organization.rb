class Organization < ActiveRecord::Base
  
  validates :legal_status, :short_title, :full_title, :inn, presence: true
  validates :inn, uniqueness: true
  
end
