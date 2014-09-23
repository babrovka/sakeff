FactoryGirl.define do
  factory :unit_bubble do
    bubble_type { rand(4) }
    comment { Faker::Lorem.sentence }
  end
end
