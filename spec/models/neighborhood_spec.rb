#solution spec, updated for checkin/checkout
# describe Neighborhood do
#   let(:nyc) { City.create(name: 'NYC') }
#   let(:sf) { City.create(name: 'San Francisco') }
#   let(:brighton) { Neighborhood.create(name: 'Brighton Beach', city: nyc) }
#   let(:guest) { User.create(name: 'Guest') }
#   let(:haight) { Neighborhood.create(name: 'Lower Haight', city: sf) }
#   let(:host) { User.create(name: 'Host') }
#   let(:listings) do
#     [Listing.create(
#       address: 'address',
#       description: 'description',
#       price: 1.00,
#       host: User.create(name: 'Host'),
#       title: 'title',
#       neighborhood: brighton,
#       listing_type: 'listing_type'
#     ), Listing.create(
#       address: 'address',
#       description: 'description',
#       price: 1.00,
#       host: User.create(name: 'Host'),
#       title: 'title',
#       neighborhood: haight,
#       listing_type: 'listing_type'
#     )]
#   end
#   let!(:reservations) do
#     Reservation.create(
#       checkin: '2014-04-25',
#       checkout: '2014-04-30',
#       listing: listings[0],
#       guest: guest,
#       status: 'accepted'
#     )
#
#     Reservation.create(
#       checkin: '2014-03-10',
#       checkout: '2014-03-25',
#       listing: listings[1],
#       guest: guest,
#       status: 'accepted'
#     )
#
#     Reservation.create(
#       checkin: '2014-06-02',
#       checkout: '2014-06-30',
#       listing: listings[1],
#       guest: guest,
#       status: 'accepted'
#     )
#   end
#
#   it '#name' do
#     expect(brighton.name).to eq('Brighton Beach')
#   end
#
#   it '#city' do
#     expect(brighton.city).to eq(nyc)
#   end
#
#   it 'has many listings' do
#     expect(brighton.listings).to include(listings[0])
#   end
#
#   it '#neighborhood_openings' do
#     expect(brighton.neighborhood_openings('2014-05-01', '2014-05-05')).to include(listings[0])
#   end
#
#   it '.highest_ratio_reservations_to_listings' do
#     binding.pry
#     expect(Neighborhood.highest_ratio_reservations_to_listings).to eq(haight)
#   end
#
#   it '.most_reservations' do
#     expect(Neighborhood.most_reservations).to eq(haight)
#   end
# end


#master spec
describe Neighborhood do
  describe 'associations' do
    it 'has a name' do
      expect(@nabe3.name).to eq('Brighton Beach')
    end

    it 'belongs to a city' do
      expect(@nabe3.city.name).to eq('NYC')
    end

    it 'has many listings' do
      expect(@nabe3.listings).to include(@listing3)
    end
  end

  describe 'instance methods' do
    it 'knows about all the available listings given a date range' do
      expect(@nabe1.neighborhood_openings('2014-05-01', '2014-05-05')).to include(@listing2)
      expect(@nabe1.neighborhood_openings('2014-05-01', '2014-05-05')).to_not include(@listing1)
    end
  end

  describe 'class methods' do
    describe ".highest_ratio_reservations_to_listings" do #method name changed in block to match solution specs
      it 'knows the neighborhood with the highest ratio of reservations to listings' do
        expect(Neighborhood.highest_ratio_reservations_to_listings).to eq(@nabe1)
      end
      it "doesn't hardcode the neighborhood with the highest ratio" do
        make_denver
        expect(Neighborhood.highest_ratio_reservations_to_listings).to eq(Neighborhood.find_by(:name => "Lakewood"))
      end
    end

    describe ".most_reservations" do #method name changed in block to match solution specs
      it 'knows the neighborhood with the most reservations' do
        expect(Neighborhood.most_reservations).to eq(@nabe1)
      end
      it "doesn't hardcode the neighborhood with the most reservations" do
        make_denver
        expect(Neighborhood.most_reservations).to eq(Neighborhood.find_by(:name => "Lakewood"))
      end
    end
  end
end
