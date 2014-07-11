# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
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

@listing4 = Listing.create(address: '4782 Yaya Lane', listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: 400.00, neighborhood_id: Neighborhood.find_by(:name => "Pacific Heights").id, host_id: User.find_by(id: 3).id)

@reservation1 = Reservation.create(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: 1, guest_id: 4, :status => "accepted")

@reservation2 = Reservation.create(checkin: '2014-03-10', checkout: '2014-03-25', listing_id: Listing.find_by(id: 2).id, guest_id: User.find_by(id: 5).id, :status => "accepted")

@reservation3 = Reservation.create(checkin: '2014-06-02', checkout: '2014-06-30', listing_id: Listing.last.id, guest_id: User.find_by(id: 6).id, :status => "accepted")

@review1 = Review.create(description: "This place was great!", rating: 5, guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)

@review2 = Review.create(description: "Great place, close to subway!", rating: 4, guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)

@review3 = Review.create(description: "Meh, the host I shared a room with snored.", rating: 3, guest_id: User.find_by(id: 6).id, listing_id: Listing.last.id)