FactoryGirl.define do
  factory :review do
    description Faker::Hacker.say_something_smart
    rating      Faker::Number.between(1, 10)
    association :reservation
  end
end