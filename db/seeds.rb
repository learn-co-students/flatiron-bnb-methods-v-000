# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
cities = City.create([{ name: 'NYC' }, { name: 'San Fransisco' }])

Neighborhood.create(name: 'Fi Di', city_id: City.first.id)
Neighborhood.create(name: 'Green Point', city_id: City.first.id)
Neighborhood.create(name: 'Brighton Beach', city_id: City.first.id)
Neighborhood.create(name: 'Pacific Heights', city_id: City.last.id)
Neighborhood.create(name: 'Mission District', city_id: City.last.id)

users =  6.times {|i| User.create(name: "User_#{i}")}

Listing.create(address: '123 Main Street', listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to subway....blah blah", price: "50.00", neighborhood_id: Neighborhood.first.id, host_id: User.first.id)

Listing.create(address: '6 Maple Street', listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: "15.00", neighborhood_id: Neighborhood.find_by(id: 2).id, host_id: User.find_by(id: 2).id)

Listing.create(address: '44 Ridge Lane', listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: "200.00", neighborhood_id: Neighborhood.find_by(id: 3).id, host_id: User.find_by(id: 3).id)

Reservation.create(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: Listing.first.id, guest_id: User.find_by(id: 4).id)

Reservation.create(checkin: '2014-03-10', checkout: '2014-03-25', listing_id: Listing.find_by(id: 2).id, guest_id: User.find_by(id: 5).id)

Reservation.create(checkin: '2014-06-02', checkout: '2014-06-30', listing_id: Listing.last.id, guest_id: User.find_by(id: 6).id)

Review.create(description: "This place was great!", rating: 5, guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)

Review.create(description: "Great place, close to subway!", rating: 4, guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)

Review.create(description: "Meh, the host I shared a room with snored.", rating: 3, guest_id: User.find_by(id: 6).id, listing_id: Listing.last.id)