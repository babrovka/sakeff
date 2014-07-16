FactoryGirl.define do

  sequence(:email) { |n| "super_user_#{n}@test.mail" }

  factory :super_user do
    email { generate(:email) }
    password 'password'
    password_confirmation 'password'
  end

end