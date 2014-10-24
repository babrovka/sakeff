require 'rails_helper'

describe Permit do
  let(:permit) { create(:permit) }
  let(:permit_without_human_and_drive_list) { create(:permit, :without_human, :without_drive_list) }
  

  describe "available print types" do

    describe '#once? permit' do
      
      it "is possible when start and expire dates are the same" do
        expect(permit.once?).to be_truthy
      end
      
      it "is impossible when start and expire dates are different" do
        permit.expires_at = (Time.now + 2.days)
        permit.save!
        permit.reload
        expect(permit.once?).to be_falsey
      end
      
      it "is impossible without location" do
        permit.location = nil
        permit.save
        permit.reload
        expect(permit.once?).to be_falsey
      end
      
      it "is impossible without person" do
        permit.person = nil
        permit.save
        permit.reload
        expect(permit.once?).to be_falsey
      end 
      
      it "is should have human or drive_list" do
        expect(permit_without_human_and_drive_list.once?).to be_falsey
      end
    end
    
    describe '#car? permit' do      
      it "is possible when car related fields are fulfilled" do
        expect(permit.car?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[vehicle_type car_brand car_number region].each do |field|
          permit = FactoryGirl.create(:permit)
          permit.update_attribute(field, nil)
          permit.save
          permit.reload
          expect(permit.car?).to be_falsey
        end
      end
    end
    
    describe '#human? permit' do
      
      it "is possible when human related fields are fulfilled" do
        permit.drive_list = false
        permit.save
        permit.reload
        expect(permit.human?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[first_name last_name middle_name doc_type doc_number].each do |field|
          permit = FactoryGirl.create(:permit)
          permit.update_attribute(field, nil)
          permit.save
          permit.reload
          expect(permit.human?).to be_falsey
        end
      end
      
      it "is impossible when drive_list exists" do
        permit.drive_list = true
        permit.save
        permit.reload
        expect(permit.human?).to be_falsey
      end
    end
  
  end

  
  
  describe 'validation' do
    
    it "couldn't be empty" do
      p = Permit.create
      expect(p.valid?).to be_falsey
    end

  end

end
