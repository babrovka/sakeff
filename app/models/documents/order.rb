# == Schema Information
#
# Table name: orders
#
#  id         :uuid             not null, primary key
#  deadline   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  started_at :datetime
#

module Documents
  class Order < ActiveRecord::Base
    include Accountable

    has_one :report

    has_one :task_list, dependent: :destroy

    has_many :tasks, through: :task_list

    accepts_nested_attributes_for :task_list, allow_destroy: true

    validates_presence_of :task_list

    validates :deadline, timeliness: {
      # on_or_after: -> { DateTime.now + 3.days }, # blocks 'state' update
      type: :date
    }

    def completed?
      task_list && task_list.completed
    end
  end
end
