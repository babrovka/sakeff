# == Schema Information
#
# Table name: document_attached_files
#
#  id                      :uuid             not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  document_id             :uuid
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class DocumentAttachedFile < ActiveRecord::Base
  belongs_to :document

  # TODO: it causes an error if the file does not image-type
  #has_attached_file :attachment, :styles => { :pdf_thumbnail => ["171x264#", :png] }

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
end
