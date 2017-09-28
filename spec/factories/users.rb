FactoryGirl.define do
  factory :user do
    email Faker::Internet.safe_email
    password Faker::Internet.password(8)
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    role 'customer'
    status 'active'
  end
end
