# coding: utf-8
# == Schema Information
#
# Table name: reports
#
#  id         :uuid             not null, primary key
#  order_id   :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reports_on_order_id  (order_id)
#

module Documents
  class Report < ActiveRecord::Base
    include Accountable
    belongs_to :order

    validates_presence_of :order_id
  end
end
