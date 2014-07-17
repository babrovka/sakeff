class Control::ActiveRegulation
  attr_reader :regulation

  def initialize
    @regulation = Control::Regulation.order('activated_at DESC').limit(1).first
  end
end