# == Schema Information
#
# Table name: constructions
#
#  id         :integer          not null, primary key
#  state      :integer
#  comment    :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Used for a 3d model of units
class Construction < ActiveRecord::Base

  def as_json _
    { id: name, comment: comment, state: state }
   end
end
