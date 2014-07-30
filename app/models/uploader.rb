# == Schema Information
#
# Table name: uploaders
#
#  id                :integer          not null, primary key
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Uploader < ActiveRecord::Base
  has_attached_file :file
  validates_attachment :file, :presence => true
  do_not_validate_attachment_file_type :file
end
