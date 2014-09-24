FactoryGirl.define do

  # sequence(:number) { |n| n }

  factory :control_state, class: Control::State do
    name { "Control Name #{generate(:number)}" }
    system_name { "control_name_#{generate(:number)}" }
    is_normal false

    trait :is_normal do
      is_normal true
    end
  end

end