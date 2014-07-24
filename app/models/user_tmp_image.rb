# == Schema Information
#
# Table name: user_tmp_images
#
#  id                 :integer          not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class UserTmpImage < ActiveRecord::Base
  has_attached_file :image, :styles => { :menu => ["26x26#",:png], :page => ["100x100#", :png] },
                    :default_url => "/user_tmp_images/:style/missing.jpg"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  belongs_to :user
end
