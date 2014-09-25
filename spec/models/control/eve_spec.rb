require 'rails_helper'

# Initial state
describe Control::Eve do
  before :all do
    FactoryGirl.create(:control_state, :is_normal)
    FactoryGirl.create(:control_state)
    Control::Eve.instance.reset
  end

  let!(:eve) {Control::Eve.instance}

  context "in initial state" do
    it "should start with normal global state" do
      expect(eve.global_state.is_normal).to be == true
    end

    it "should return positive overall status" do
      expect(eve.overall_state).to be == true 
    end
  end
end

# Non-initial state
describe Control::Eve do
  let!(:eve) {Control::Eve.instance}

  it "should be able to change global state" do    
    another_state = Control::State.where.not(is_normal: true).first
    expect {eve.change_global_state_to another_state}.to change {eve.global_state}.to another_state
  end

end