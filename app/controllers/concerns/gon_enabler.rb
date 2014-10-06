# Enables gon for ruby-js interaction
module GonEnabler
  extend ActiveSupport::Concern

  # Enables gon
  def gon_enable
    gon.push({has_gon: true})
    gon.push({ current_user: { id: current_user.id } }) if current_user
  end

end