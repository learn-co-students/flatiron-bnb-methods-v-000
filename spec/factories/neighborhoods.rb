FactoryGirl.define do
  factory :neighborhood do
    name Faker::Address.city
    association :city
  end
end