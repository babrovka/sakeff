FactoryGirl.define do

  sequence(:username) { |n| "username_#{n}" }
  sequence(:number) { |n| n }

  factory :user do
    username { generate(:username) }
    first_name { "FirstName_#{generate(:number)}" }
    last_name { "LastName_#{generate(:number)}" }
    middle_name { "MiddleName_#{generate(:number)}" }
    password 'password'
    password_confirmation 'password'
    title 'job_title'

    organization
  end

end