# == Schema Information
#
# Table name: im_dialogues
#
#  id         :uuid             not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Im::Dialogue < ActiveRecord::Base
  has_and_belongs_to_many :users, 
                          class_name: 'User',
                          join_table: "user_dialogues"
  has_many :messages
  accepts_nested_attributes_for :messages, allow_destroy: true

  before_save :set_users


  private

  def set_users
    self.users ||= self.messages.first.recipients + [self.messages.first.sender]
  end

end
