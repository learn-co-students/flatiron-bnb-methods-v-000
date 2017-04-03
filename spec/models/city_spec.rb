# solution spec, updated for checkin/checkout
# describe City do
#   let(:nyc) { City.create(name: 'NYC') }
#   let(:denver) { City.create(name: 'Denver') }
#   let!(:nabe1) { Neighborhood.create(name: 'FiDi', city: nyc) }
#   let!(:nabe2) { Neighborhood.create(name: 'Green Point', city: nyc) }
#   let!(:nabe3) { Neighborhood.create(name: 'Brighton Beach', city: nyc) }
#   let!(:nabe4) { Neighborhood.create(name: 'LoDo', city: denver) }
#
#   it 'has a name' do
#     expect(nyc.name).to eq('NYC')
#   end
#
#   it 'has many neighborhoods' do
#     expect(nyc.neighborhoods).to eq([nabe1, nabe2, nabe3])
#   end
#
#   describe "listings and reservations" do
#     let(:guest) { User.create(name: 'Guest') }
#     let(:host) { User.create(name: 'Host') }
#     let(:listings) do
#       [Listing.create(
#         address: '123 Main Street',
#         listing_type: "private room",
#         title: "Beautiful Apartment on Main Street",
#         description: "My apartment is great. there's a bedroom. close to subway....blah blah",
#         price: 50.00,
#         neighborhood: nabe1,
#         host: host
#       ), Listing.create(
#          address: '6 Maple Street',
#          listing_type: "shared room",
#          title: "Shared room in apartment",
#          description: "shared a room with me because I'm poor",
#          price: 15.00,
#          neighborhood: nabe1,
#          host: host
#        ), Listing.create(
#          address: '44 Ridge Lane',
#          listing_type: "whole house",
#          title: "Beautiful Home on Mountain",
#          description: "Whole house for rent on mountain. Many bedrooms.",
#          price: 200.00,
#          neighborhood: nabe3,
#          host: host
#        ), Listing.create(
#          address: '4782 Yaya Lane',
#          listing_type: "private room",
#          title: "Beautiful Room in awesome house",
#          description: "Art collective hosue.",
#          price: 400.00,
#          neighborhood: nabe4,
#          host: host
#        )]
#     end
#
#     let!(:reservations) do
#       Reservation.create(
#         checkin: '2014-04-25',
#         checkout: '2014-04-30',
#         listing: listings[0],
#         guest: guest,
#         status: 'accepted'
#       )
#
#       Reservation.create(
#         checkin: '2014-03-10',
#         checkout: '2014-03-25',
#         listing: listings[1],
#         guest: guest,
#         status: 'accepted'
#       )
#
#       Reservation.create(
#         checkin: '2014-06-02',
#         checkout: '2014-06-30',
#         listing: listings[2],
#         guest: guest,
#         status: 'accepted'
#       )
#
#       Reservation.create(
#         checkin: '2014-05-02',
#         checkout: '2014-05-08',
#         listing: listings[0],
#         guest: guest,
#         status: 'accepted'
#       )
#
#       Reservation.create(
#         checkin: '2014-05-10',
#         checkout: '2014-05-15',
#         listing: listings[0],
#         guest: guest,
#         status: 'accepted'
#       )
#     end
#
#     describe "#city_openings" do
#       it 'knows about all the available listings given a date range' do
#         expect(
#           nyc.city_openings('2014-05-01', '2014-05-05')
#         ).to include(listings[1], listings[2])
#       end
#     end
#
#     describe ".highest_ratio_reservations_to_listings" do
#       it 'knows the city with the highest ratio of reservations to listings' do
#         expect(
#           City.highest_ratio_reservations_to_listings
#         ).to eq(nyc)
#       end
#
#       it "doesn't hardcode the city with the highest ratio of reservations to listings" do
#         expect(
#           City.highest_ratio_reservations_to_listings
#         ).to eq(nyc)
#       end
#     end
#
#     describe ".most_reservations" do
#       it 'knows the city with the most reservations' do
#         expect(City.most_reservations).to eq(nyc)
#       end
#
#       it 'knows the city with the most reservations' do
#         expect(City.most_reservations).to eq(nyc)
#       end
#     end
#   end
# end

# master spec
describe City do
  describe 'associations' do
    it 'has a name' do
      expect(City.first.name).to eq('NYC')
    end

    it 'has many neighborhoods' do
      expect(City.first.neighborhoods).to eq([@nabe1, @nabe2, @nabe3])
    end
  end

  describe 'instance methods' do
    it 'knows about all the available listings given a date range' do

      expect(City.first.city_openings('2014-05-01', '2014-05-05')).to include(@listing2,@listing3)

      expect(City.first.city_openings('2014-05-01', '2014-05-05')).to_not include(@listing1)
    end
  end

  describe 'class methods' do
    describe ".highest_ratio_reservations_to_listings" do #method name changed in block to match requirement in solution branch
      it 'knows the city with the highest ratio of reservations to listings' do
        expect(City.highest_ratio_reservations_to_listings).to eq(City.find_by(:name => "NYC"))
      end

      it "doesn't hardcode the city with the highest ratio of reservations to listings" do
        make_denver
        expect(City.highest_ratio_reservations_to_listings).to eq(City.find_by(:name => "Denver"))
      end
    end

    describe ".most_reservations" do  #method name changed in block to match requirement in solution branch
      it 'knows the city with the most reservations' do
        expect(City.most_reservations).to eq(City.find_by(:name => "NYC"))
      end

      it 'knows the city with the most reservations' do
        make_denver
        expect(City.most_reservations).to eq(City.find_by(:name => "Denver"))
      end
    end
  end
end
