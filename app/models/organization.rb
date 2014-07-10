class Organization < ActiveRecord::Base
  
  validates :legal_status, :short_title, :full_title, :inn, presence: true
  validates :inn, uniqueness: true
  validates :inn, numericality: true
  validates :inn, length: { is: 10 }

  enum legal_status: [:ip, :ooo, :zao, :oao]
  
end
