FactoryGirl.define do
  factory :message, class: Im::Message do
    text { "Message text ##{generate(:number)}"}
    sender_user { create(:user) }
    reach :broadcast

    factory :organization_message, class: Im::Message do
      reach :organization
      sender_id { create(:organization).id}
      receiver_id { create(:organization).id}
    end

    trait :organization do
      reach :organization
      sender_id { sender_user.organization.id }
      receiver_id { create(:organization).id }
    end

  end
end