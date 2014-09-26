FactoryGirl.define do
  factory :unit_bubble do
    bubble_type 1
    comment { Faker::Lorem.sentence }
  end
end
