FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role 'customer'
    status 'active'
    after(:build) do |user|
      user.account ||= FactoryGirl.build(:account, user: user)
    end

    factory :user_with_cards do
      after(:build) do |user|
        user.cards.build(last_4: "1111", card_type: Card.card_types[:credit], issuer: "visa", status: "active", expiration: 1.year.from_now.strftime("%Y/%m/%d"))
        user.cards.build(last_4: "8210", card_type: Card.card_types[:debit], issuer: "mastercard", status: "active", expiration: 1.year.from_now.strftime("%Y/%m/%d"))
      end
    end
  end
end
