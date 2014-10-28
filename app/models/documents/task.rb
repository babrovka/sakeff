class Documents::Task < ActiveRecord::Base
  # TODO: does deadline have to be in every model?
  belongs_to :task_list, touch: true

  scope :completed, -> { where(completed: true) }
  scope :not_completed, -> { where(completed: false) }
  scope :expired, -> { where("deadline < ?", Date.today) }
end
