# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :control_event, :class => 'Control::Event' do
    from_state_id 1
    to_state_id 1
    name "MyString"
    system_name "MyString"
  end
end
