FactoryGirl.define do
  factory :message, class: Im::Message do
    text { "Message text ##{generate(:number)}"}
    sender { create(:user) }
  end
end