# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :control_regulation, :class => 'Control::Regulations' do
    name "MyString"
  end
end
