FactoryGirl.define do

  factory :permission do
    title { "test_permission_#{generate(:number)}" }
    description 'тестовое право на что-то'
  end



end