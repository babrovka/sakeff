FactoryGirl.define do

  factory :permission do
    title { "test_permission_#{generate(:number)}" }
    description 'тестовое право на чтото'
  end

  factory :another_permission, class: Permission do
    title { "test_permission_#{generate(:number)}" }
    description 'еще одно тестовое право на чтото'
  end

end