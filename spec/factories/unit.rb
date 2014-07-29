FactoryGirl.define do
  factory :unit do
    id "d81c07d1-10ba-464b-b277-e22e775645ce"
    label "C1"
    has_children 1

    factory :child_unit do
      id "12f01c02-c584-4956-b60b-ac875de1fe57"
      label "Помещение1"
      parent_id "d81c07d1-10ba-464b-b277-e22e775645ce"
      has_children 0
    end

  end
end