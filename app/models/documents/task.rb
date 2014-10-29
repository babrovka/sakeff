# == Schema Information
#
# Table name: tasks
#
#  id                       :uuid             not null, primary key
#  task_list_id             :uuid
#  title                    :text
#  completed                :boolean          default(FALSE)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  document_id              :uuid
#  executor_organization_id :uuid
#  sender_organization_id   :uuid
#  deadline                 :datetime
#  executor_id              :uuid
#  creator_id               :uuid
#  approver_id              :uuid
#  executor_comment         :text
#  body                     :text
#

class Documents::Task < ActiveRecord::Base
  # TODO: does deadline have to be in every model?
  belongs_to :task_list, touch: true

  scope :completed, -> { where(completed: true) }
  scope :not_completed, -> { where(completed: false) }
  scope :expired, -> { where("deadline < ?", Date.today) }
end
