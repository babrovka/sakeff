FactoryGirl.define do

  factory :role do
    title { "test_role_#{generate(:number)}" }
    description 'тестовая роль'
  end

  factory :role_with_permissions, parent: :role do

    before(:build) do |instance|
      rand(1..7).times do
        instance.permissions << build(:permission)
      end
    end

    before(:create) do |instance|
      rand(1..7).times do
        instance.permissions << create(:permission)
      end
    end

  end


end