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
    drive_list true

    trait :car do
      car true
    end

    trait :human do
      human true
    end

    trait :once do
      once true
    end

    trait :not_expired do
      expires_at t + 3.days
    end

    trait :without_drive_list do
      drive_list false
    end
    
  end
  
  
  
end