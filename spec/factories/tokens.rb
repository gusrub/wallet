FactoryGirl.define do
  factory :token do
    token_type 'session'
    association :user, factory: :user
  end
end
