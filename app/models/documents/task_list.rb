# == Schema Information
#
# Table name: task_lists
#
#  id         :uuid             not null, primary key
#  order_id   :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deadline   :datetime
#
# Indexes
#
#  index_task_lists_on_order_id  (order_id)
#

class Documents::TaskList < ActiveRecord::Base
  belongs_to :order
  has_many :tasks

  accepts_nested_attributes_for :tasks, allow_destroy: true

  #validates :tasks, length: {minimum: 1}

  def progress
    if tasks.present?
      total = tasks.count.to_f
      completed = tasks.completed.count.to_f
      (completed / total * 100).ceil
    else
      0
    end
  end

  def completed
    tasks.count > 0 && tasks.map(&:completed).all?
  end

  alias_method :completed?, :completed
end
