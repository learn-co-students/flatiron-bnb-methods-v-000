FactoryGirl.define do
  factory :reservation do
    association :listing
    association :guest, :factory => :user
    checkin 1.year.ago
    checkout 1.year.ago + 2.days
  end
end