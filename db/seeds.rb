
def make_seeds
  # make_cities
  # make_neighborhoods
  # make_users
  # make_listings
  # make_reservations
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

  @listing1 = Listing.create(address: '123 Main Street', listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to subway....blah blah", price: 50.00, neighborhood_id: @nabe1.id, host_id: User.first.id)
  @listing2 = Listing.create(address: '6 Maple Street', listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: 15.00, neighborhood_id: @nabe1.id, host_id: @katie.id)
  @listing3 = Listing.create(address: '44 Ridge Lane', listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: 200.00, neighborhood_id: @nabe3.id, host_id: @arel.id)
  @listing4 = Listing.create(address: '4782 Yaya Lane', listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: 400.00, neighborhood_id: @nabe4.id, host_id: @arel.id)

  @reservation1 = Reservation.create(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: @listing1.id, guest_id: @logan.id, :status => "accepted")
  @reservation2 = Reservation.create(checkin: '2014-03-10', checkout: '2014-03-25', listing_id: @listing2.id, guest_id: @tristan.id, :status => "accepted")
  @reservation3 = Reservation.create(checkin: '2014-06-02', checkout: '2014-06-30', listing_id: @listing4.id, guest_id: @avi.id, :status => "accepted")
  @reservation4 = Reservation.create(checkin: '2014-05-02', checkout: '2014-05-08', listing_id: @listing1.id, guest_id: @tristan.id, :status => "accepted")
  @reservation5 = Reservation.create(checkin: '2014-05-10', checkout: '2014-05-15', listing_id: @listing1.id, guest_id: @logan.id, :status => "accepted")

  @review1 = Review.create(description: "This place was great!", rating: 5, guest_id: @logan.id, reservation_id: Reservation.first.id)
  @review2 = Review.create(description: "Great place, close to subway!", rating: 4, guest_id: @tristan.id, reservation_id: Reservation.first.id)
  @review3 = Review.create(description: "Meh, the host I shared a room with snored.", rating: 3, guest_id: @avi.id, reservation_id: Reservation.last.id)
  make_denver
end

def make_denver
  denver = City.create(:name => "Denver")
  lakewood = Neighborhood.create(name: 'Lakewood', city_id: denver.id)
  listing = Listing.create(
    address: '9300 W. Mountain Ave.',
    listing_type: "private room",
    title: "pretty cabin outside of the city",
    description: "My cabin is great. I have a coffeemaker",
    price: 20.00,
    neighborhood_id: lakewood.id,
    host_id: User.first.id
  )
  checkin_day = 1
  6.times do |i|
    guest_id = i + 1
    if guest_id != listing.host.id
      Reservation.create(
        checkin: "2014-08-#{checkin_day}",
        checkout: "2014-08-#{checkin_day + 3}",
        listing_id: listing.id,
        guest_id: "#{guest_id}",
        status: "accepted"
      )
      checkin_day += 5
    end
  end
end

def make_cities
  ["New York City", "San Diego", "Woodstock"].each {|n| City.create(name: n) }
end

def make_neighborhoods
  ['Fi Di','Green Point','Brighton Beach','Pacific Heights','Mission District'].each do |name|
    Neighborhood.create(name: name, city_id: City.first.id)
  end
end

def make_users
  ["Amanda", "Katie","Arel","Logan","Tristan","Avi"].each do |name|
    User.create(name: name)
  end
end

def make_listings
  Listing.create(address: '123 Main Street', listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to subway....blah blah", price: 50.00, neighborhood_id: Neighborhood.first.id, host_id: User.first.id)
  Listing.create(address: '6 Maple Street', listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: 15.00, neighborhood_id: Neighborhood.find_by(id: 2).id, host_id: User.find_by(id: 2).id)
  Listing.create(address: '44 Ridge Lane', listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: 200.00, neighborhood_id: Neighborhood.find_by(id: 3).id, host_id: User.find_by(id: 3).id)
  Listing.create(address: '4782 Yaya Lane', listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: 400.00, neighborhood_id: Neighborhood.find_by(:name => "Pacific Heights").id, host_id: User.find_by(id: 3).id)
end

def make_reservations
  # first listing
  Reservation.create!(checkin: '2014-01-01', checkout: '2014-01-07', listing_id: 1, guest_id: User.last.id, :status => "accepted")
  Reservation.create!(checkin: '2014-01-09', checkout: '2014-01-20', listing_id: 1, guest_id: 5, :status => "accepted")
  Reservation.create!(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: 1, guest_id: 4, :status => "accepted")
  # second listing
  Reservation.create!(checkin: '2014-03-10', checkout: '2014-03-25', listing_id: Listing.find(2).id, guest_id: User.find_by(id: 5).id, :status => "accepted")
  # last listing
  Reservation.create!(checkin: '2014-06-02', checkout: '2014-06-30', listing_id: Listing.last.id, guest_id: User.find(6).id, :status => "accepted")
  Reservation.create!(checkin: '2014-05-15', checkout: '2014-06-01', listing_id: Listing.last.id, guest_id: User.find(5).id, :status => "accepted")
end

def make_reviews
  Review.create(description: "This place was great!", rating: 5, guest_id: User.find_by(id: 4).id, reservation_id: Reservation.first.id)
  Review.create(description: "Great place, close to subway!", rating: 4, guest_id: User.find_by(id: 5).id, reservation_id: Reservation.find_by(id: 2).id)
  Review.create(description: "Meh, the host I shared a room with snored.", rating: 3, guest_id: User.find_by(id: 6).id, reservation_id: Reservation.last.id)
end

make_seeds
