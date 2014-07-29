FactoryGirl.define do
  factory :unit do
    id "d81c07d1-10ba-464b-b277-e22e775645ce"
    label "C1"
    has_children 2
  end

  factory :child_unit, class: Unit do
    id "12f01c02-c584-4956-b60b-ac875de1fe57"
    label "Помещение1"
    parent_id "d81c07d1-10ba-464b-b277-e22e775645ce"
    has_children 1
  end

  factory :grandchild_unit, class: Unit do
    id "d81c07d1-c584-4956-b60b-ac855de1fe57"
    label "Склад3"
    parent_id "12f01c02-c584-4956-b60b-ac875de1fe57"
    has_children 0
  end

end