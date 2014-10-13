# == Schema Information
#
# Table name: conformations
#
#  id          :uuid             not null, primary key
#  document_id :uuid
#  user_id     :uuid
#  conformed   :boolean
#  comment     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_conformations_on_document_id_and_user_id  (document_id,user_id) UNIQUE
#

class Conformation < ActiveRecord::Base
  validates :comment, presence: {message: 'Коментарий обязателен при отказе согласования.'}, if: lambda {conformed == false}
  validates :document_id, presence: true
  validates :user_id, presence: true

  belongs_to :document
  belongs_to :user
end
