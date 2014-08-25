FactoryGirl.define do
  factory :unit_bubble do
    bubble_type { rand(4) }
    unit
    comment { Faker::Lorem.sentence }
  end
end
