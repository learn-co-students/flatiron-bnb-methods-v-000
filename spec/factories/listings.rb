FactoryGirl.define do
  factory :listing do
    address Faker::Address.street_address
    association :neighborhood
    listing_type { ['Apartment', 'Home', 'Mansion'].sample }
    title "The #{Faker::Company.name}"
    description Faker::Company.catch_phrase
    price Faker::Commerce.price.to_f
  end
end



# We need a linter for programming
  # single source of truth
  # where to call the methods - no calls to the database from the view
  # IF use a noun name - filter into another object
  # method length
  # class length 
# Ways to improve
  # Address should be its own object
    # And should then link to neighborhood and city
  # Reservation - should be the only link to a review
  # User - host, and guest
  # Stop using callbacks that call other objects

  # Look at rajat's project
    # Use gosu - to do 
    # https://github.com/rajatagrawal/Tetris