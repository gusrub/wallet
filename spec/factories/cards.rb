FactoryGirl.define do
  factory :card do
    last_4 "1111"
    card_type "credit"
    issuer "visa"
    status "active"
    expiration 1.year.from_now.strftime("%Y/%m/%d")
    association :user, factory: :user
  end
end
