FactoryGirl.define do

  factory :dialogue, class: Im::Dialogue do
    ignore do
      sender { create(:user) }
      recipients { 3.times.map { create(:user) } }
    end

    messages do
      5.times.map do
        create(:message, sender: sender, recipients: recipients)
      end
    end

    users{ recipients.push sender }
  end

end