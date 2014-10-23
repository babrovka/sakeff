FactoryGirl.define do

  factory :permit, class: Permit do
    t = Time.now
    starts_at t
    expires_at t
    person 'test'
    location 'test'
    vehicle_type 'passenger'
    car_brand 'volvo'
    car_number 'K532CB'
    region '178'
    first_name 'first_name'
    last_name 'last_name'
    middle_name 'middle_name'
    doc_type 'passport'
    doc_number '12345678'
  end
  
end