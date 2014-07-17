class Control::ActiveRegulationFactory

  class << self; attr_accessor :applicable_states end

  def self.construct
    ar = Control::ActiveRegulation.new
    
    self.applicable_states = ar.regulation.states
    
    class << ar
      include Workflow
      workflow do
        Control::ActiveRegulationFactory.applicable_states.each do |st|
          state st.system_name
        end
      end
    end

    ar
  end

end