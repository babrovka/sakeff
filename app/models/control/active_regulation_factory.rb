class Control::ActiveRegulationFactory

  class << self; attr_accessor :applicable_states end
  class << self; attr_accessor :active_regulation end

  def self.construct
    ar = Control::ActiveRegulation.new
    
    self.applicable_states = ar.regulation.states
    
    class << ar
      include Workflow
      workflow do
        Control::ActiveRegulationFactory.applicable_states.each do |st|
          state st.system_name do
            st.events.each do |ev|
              event ev.system_name, transitions_to: ev.target_state.system_name
            end
          end
        end
      end
    end

    self.active_regulation = ar
  end

  def self.get_regulation
    self.construct unless self.active_regulation
    self.active_regulation
  end

end