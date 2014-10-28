FactoryGirl.define do

  # sequence(:number) { |n| n }

  factory :control_state, class: Control::State do
    name { "Control Name #{generate(:number)}" }
    system_name { name.gsub(' ', '_').underscore }
    is_normal false

    trait :is_normal do
      is_normal true
    end
  end

end