# == Schema Information
#
# Table name: favourite_units
#
#  id         :integer          not null, primary key
#  unit_id    :uuid
#  user_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#


class FavouriteUnit < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit
end
