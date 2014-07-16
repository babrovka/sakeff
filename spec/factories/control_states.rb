# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :control_state, :class => 'Control::State' do
    name "MyString"
    system_name "MyString"
    control_regulation_id 1
  end
end
