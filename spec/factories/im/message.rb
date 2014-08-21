FactoryGirl.define do

  factory :message, class: Im::Message do

    text { "Message text ##{generate(:number)}"}
    recipients { [create(:user)] }
    sender { create(:user) }

  end

end