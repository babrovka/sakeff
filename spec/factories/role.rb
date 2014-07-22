FactoryGirl.define do

  factory :role do
    title { "test_role_#{generate(:number)}" }
    description 'тестовая роль'
  end

  factory :role_with_permissions, parent: :role do


    # используем after для build, иначе не к чему прикреплять Permission
    after(:build) do |instance|
      rand(1..7).times do |i|
        instance.permissions << build(:permission)
        instance.role_permissions[i].result = [:default, :granted, :forbidden].sample
      end
    end

    before(:create) do |instance|
      rand(1..7).times do |i|
        instance.permissions << create(:permission)
        instance.role_permissions[i].result = [:default, :granted, :forbidden].sample
      end
    end

  end


end