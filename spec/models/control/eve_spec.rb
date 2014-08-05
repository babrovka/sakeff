require 'rails_helper'

describe Control::Eve do
  let!(:eve) {Control::Eve.instance}

  context "in initial state" do
    it "should start with normal global state" do
      expect(eve.global_state.is_normal) == true
    end

    it "should return positive overall status" do
      expect(eve.overall_state) == true 
    end
  end

  it "should be able to change global state" do    
    another_state = Control::State.where(is_normal: false).first
    expect {eve.change_global_state_to another_state}.to change {eve.global_state}.to another_state
  end

end