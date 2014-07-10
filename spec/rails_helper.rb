# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  DatabaseCleaner.strategy = :truncation

  config.after(:all) do 
    DatabaseCleaner.clean
  end

  config.before(:each) do 
    cities = City.create([{ name: 'NYC' }, { name: 'San Fransisco' }])

    @nabe1 = Neighborhood.create(name: 'Fi Di', city_id: City.first.id)
    @nabe2 = Neighborhood.create(name: 'Green Point', city_id: City.first.id)
    @nabe3 = Neighborhood.create(name: 'Brighton Beach', city_id: City.first.id)
    @nabe4 = Neighborhood.create(name: 'Pacific Heights', city_id: City.last.id)
    @nabe5 = Neighborhood.create(name: 'Mission District', city_id: City.last.id)

    @amanda = User.create(name: "Amanda")
    @katie = User.create(name: "Katie")
    @arel = User.create(name: "Arel")
    @logan = User.create(name: "Logan")
    @tristan = User.create(name: "Tristan")
    @avi = User.create(name: "Avi")

    @listing1 = Listing.create(address: '123 Main Street', listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to subway....blah blah", price: 50.00, neighborhood_id: Neighborhood.first.id, host_id: User.first.id)

    @listing2 = Listing.create(address: '6 Maple Street', listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: 15.00, neighborhood_id: Neighborhood.find_by(id: 2).id, host_id: User.find_by(id: 2).id)

    @listing3 = Listing.create(address: '44 Ridge Lane', listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: 200.00, neighborhood_id: Neighborhood.find_by(id: 3).id, host_id: User.find_by(id: 3).id)

    @reservation1 = Reservation.create(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: Listing.first.id, guest_id: User.find_by(id: 4).id)

    @reservation2 = Reservation.create(checkin: '2014-03-10', checkout: '2014-03-25', listing_id: Listing.find_by(id: 2).id, guest_id: User.find_by(id: 5).id)

    @reservation3 = Reservation.create(checkin: '2014-06-02', checkout: '2014-06-30', listing_id: Listing.last.id, guest_id: User.find_by(id: 6).id)

    @review1 = Review.create(description: "This place was great!", rating: 5, guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)

    @review2 = Review.create(description: "Great place, close to subway!", rating: 4, guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)

    @review3 = Review.create(description: "Meh, the host I shared a room with snored.", rating: 3, guest_id: User.find_by(id: 6).id, listing_id: Listing.last.id)
  end
end
