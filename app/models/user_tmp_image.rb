class UserTmpImage < ActiveRecord::Base
  has_attached_file :image, :styles => { :menu => ["100x100#",:png], :page => ["180x180#", :png] }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
end
