# Enables gon for ruby-js interaction
module GonEnabler
  extend ActiveSupport::Concern

  # Enables gon
  def gon_enable
    gon.push({
                 has_gon: true,
                 current_user: { id: current_user.id }
             })
  end

end