class UserTmpImage < ActiveRecord::Base
  has_attached_file :image, :styles => { :menu => ["26x26#",:png], :page => ["100x100#", :png] },
                    :default_url => "/user_tmp_images/:style/missing.jpg"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  belongs_to :user
end
