class Control::Eve

  attr_accessor :global_state
  
  def initialize
    self.global_state = Control::State.where(is_normal: true).first
  end

  def change_global_state_to state
    self.global_state = state
  end

end