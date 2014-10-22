FactoryGirl.define do

  factory :once_permit, class: Permit do
    t = Time.now
    starts_at t
    expires_at t
    person 'test'
    location 'test'
  end
  
  factory :car_permit, class: Permit do
    vehicle_type 'passenger'
    car_brand 'volvo'
    car_number 'K532CB'
    region '178'
  end
  
  factory :human_permit, class: Permit do
    first_name 'first_name'
    last_name 'last_name'
    middle_name 'middle_name'
    doc_type 'passport'
    doc_number '12345678'
  end
  
end