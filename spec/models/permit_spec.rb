require 'rails_helper'

describe Permit do
  let(:once_permit) { create(:once_permit) }
  let(:car_permit) { create(:car_permit) }
  let(:human_permit) { create(:human_permit) }
  

  describe "available print types" do

    describe '#once? permit' do
      
      it "is possible when start and expire dates are the same" do
        once_permit.save!
        once_permit.reload
        expect(once_permit.once?).to be_truthy
      end
      
      it "is impossible when start and expire dates are different" do
        once_permit.expires_at = (Time.now + 2.days)
        once_permit.save!
        once_permit.reload
        expect(once_permit.once?).to be_falsey
      end
      
      it "is impossible without location" do
        once_permit.location = nil
        once_permit.save!
        once_permit.reload
        expect(once_permit.once?).to be_falsey
      end
      
      it "is impossible without person" do
        once_permit.person = nil
        once_permit.save!
        once_permit.reload
        expect(once_permit.once?).to be_falsey
      end 
    end
    
    describe '#car? permit' do      
      it "is possible when car related fields are fulfilled" do
        car_permit.save!
        car_permit.reload
        expect(car_permit.car?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[vehicle_type car_brand car_number region].each do |field|
          car_permit = FactoryGirl.create(:car_permit)
          car_permit.update_attribute(field, nil)
          car_permit.save!
          car_permit.reload
          expect(car_permit.car?).to be_falsey
        end
      end
    end
    
    describe '#human? permit' do
      
      it "is possible when human related fields are fulfilled" do
        human_permit.save!
        human_permit.reload
        expect(human_permit.human?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[first_name last_name middle_name doc_type doc_number].each do |field|
          human_permit = FactoryGirl.create(:human_permit)
          human_permit.update_attribute(field, nil)
          human_permit.save!
          human_permit.reload
          expect(human_permit.human?).to be_falsey
        end
      end
      
      it "is impossible when drive_list exists" do
        human_permit.drive_list = true
        human_permit.save!
        human_permit.reload
        expect(human_permit.human?).to be_falsey
      end
    end
  
  end

end
