FactoryGirl.define do
  factory :unit do
    label "C1"
  end

  factory :child_unit, class: Unit do
    label "Помещение1"
  end

  factory :grandchild_unit, class: Unit do
    label "Склад3"
  end

end
