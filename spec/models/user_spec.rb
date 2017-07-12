#solution spec, updated for checkin/checkout
# describe User do
#   let(:nyc) { City.create(name: 'NYC') }
#   let(:neighborhood) { Neighborhood.create(name: 'Tribeca', city: nyc) }
#   let(:guest) { User.create(name: 'Guest') }
#   let(:host) { User.create(name: 'Host') }
#   let(:listing) do
#     Listing.create(
#       address: '123 Main Street',
#       description: "Whole house for rent on mountain. Many bedrooms.",
#       host: host,
#       listing_type: 'shared room',
#       neighborhood: neighborhood,
#       price: 15.00,
#       title: 'Beautiful Apartment on Main Street',
#     )
#   end
#   let!(:reservation) do
#     Reservation.create(
#       checkin: '2014-04-25',
#       checkout: '2014-04-30',
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )
#   end
#   let!(:review) do
#     Review.create(
#       description: 'awful',
#       guest: guest,
#       rating: 0,
#       reservation: reservation
#     )
#   end
#
#   it '#name' do
#     expect(guest.name).to eq('Guest')
#   end
#
#
#   context 'as host' do
#     it '#host?' do # modified to host, because master schema contains host attribute, not is_host
#       expect(host.host?).to be(true)
#     end
#
#     it 'has_many listings' do
#       expect(host.listings).to include(listing)
#     end
#
#     it 'has_many reservations through listings' do
#       expect(host.reservations).to include(reservation)
#     end
#
#     it 'has had many guests' do
#       expect(host.guests).to include(guest)
#     end
#
#     it 'has received many reviews' do
#       expect(host.host_reviews).to include(review)
#     end
#   end
#
#   context 'as guest' do
#     it 'has_many trips' do
#       expect(guest.trips)
#     end
#
#     it 'has had many hosts' do
#       expect(guest.hosts).to include(host)
#     end
#
#     it 'has written many reviews' do
#       expect(guest.reviews).to include(review)
#     end
#   end
# end

#master spec
describe User do
  describe 'associations' do
    it 'has a name' do
      expect(@katie.name).to eq("Katie")
    end

    it 'as a host has many listings' do
      expect(@amanda.listings).to include(@listing1)
    end

    it 'as a guest has many trips' do
      expect(@tristan.trips).to include(@reservation2)
    end

    it 'as a host has many reservations through their listing' do
      expect(@amanda.reservations).to include(@reservation1)
    end

    it 'as a guest has written many reviews' do
      expect(@avi.reviews).to include(@review3)
    end

    it 'as a host, knows about the guests its had' do
      expect(@amanda.guests).to include(@logan)
    end

    it 'as a guest, knows about the hosts its had' do
      expect(@logan.hosts).to include(@amanda)
    end

    it 'as a host, knows about its reviews from guests' do
      expect(@amanda.host_reviews).to include(@review1)
    end
  end
end
