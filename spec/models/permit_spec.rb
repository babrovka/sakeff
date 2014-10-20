require 'rails_helper'

describe Permit do
  let(:permit) { create(:permit) }

  describe "available print types" do

    describe '#once? permit' do
      before do
        t = Time.now
        permit.starts_at = t
        permit.expires_at = t
        permit.person = 'test'
        permit.location = 'test'
      end
      
      it "is possible when start and expire dates are the same" do
        permit.save!
        permit.reload
        expect(permit.once?).to be_truthy
      end
      
      it "is impossible when start and expire dates are different" do
        permit.expires_at = (Time.now - 2.days)
        permit.save!
        permit.reload
        expect(permit.once?).to be_falsey
      end
      
      it "is impossible without location" do
        permit.location = nil
        permit.save!
        permit.reload
        expect(permit.once?).to be_falsey
      end
      
      it "is impossible without person" do
        permit.person = nil
        permit.save!
        permit.reload
        expect(permit.once?).to be_falsey
      end 
    end
    
    describe '#car? permit' do
      before do
        permit.vehicle_type = 'passenger'
        permit.car_brand = 'volvo'
        permit.car_number = 'K532CB'
        permit.region = '178'
      end
      
      it "is possible when car related fields are fulfilled" do
        permit.save!
        permit.reload
        expect(permit.car?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[vehicle_type car_brand car_number region].each do |field|
          permit.update_attribute(field, nil)
          permit.save!
          permit.reload
          expect(permit.car?).to be_falsey
        end
      end
    end
    
    describe '#human? permit' do
      before do
        permit.first_name = 'first_name'
        permit.last_name = 'last_name'
        permit.middle_name = 'middle_name'
        permit.doc_type = 'passport'
        permit.doc_number = '12345678'
      end
      
      it "is possible when human related fields are fulfilled" do
        permit.save!
        permit.reload
        expect(permit.human?).to be_truthy
      end
      
      it "is impossible when one of required fields is empty" do
        %w[first_name last_name middle_name doc_type doc_number].each do |field|
          permit.update_attribute(field, nil)
          permit.save!
          permit.reload
          expect(permit.human?).to be_falsey
        end
      end
      
      it "is impossible when drive_list exists" do
        permit.drive_list = true
        permit.save!
        permit.reload
        expect(permit.human?).to be_falsey
      end
    end

  end

end
