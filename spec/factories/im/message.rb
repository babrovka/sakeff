FactoryGirl.define do
  factory :message, class: Im::Message do
    text { "Message text ##{generate(:number)}"}
    sender { create(:user) }
    reach :broadcast

    factory :organization_message, class: Im::Message do
      reach :organization
      sender_id { create(:organization).id}
      receiver_id { create(:organization).id}
    end
  end
end