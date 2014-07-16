FactoryGirl.define do

  sequence(:organization_title) { |n| "Organization #{n}" }
  sequence(:inn) { rand(9999999).to_s.center(10, rand(9).to_s) }

  factory :organization do
    short_title { generate(:organization_title) }
    full_title { "OOO #{short_title}" }
    inn { generate(:inn) }
    legal_status { rand(4) } # выбираем случайно одно из 4х состояний: ИП, ООО, ЗАО, ООО
  end

end