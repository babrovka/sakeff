class Control::Regulation < ActiveRecord::Base
  has_many :states

  default_scope { order('id') }

end
