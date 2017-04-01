#solution spec,updated for checkin/checkout
# describe Listing do
#   let(:city) { City.create(name: 'San Francisco') }
#   let(:neighborhood) { Neighborhood.create(name: 'Lower Haight', city: city) }
#   let(:host) { User.create(name: 'Host') }
#   let(:guest) { User.create(name: 'Guest') }
#
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
#
#   let(:reservation) do
#     Reservation.create(
#       checkin: '2015-04-03',
#       checkout: '2015-04-07',
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )
#   end
#
#   let!(:review) do
#     Review.create(
#       description: "This place was great!",
#       rating: 5,
#       guest: guest,
#       reservation: reservation
#     )
#   end
#
#   it '#title' do
#     expect(listing.title).to eq("Beautiful Apartment on Main Street")
#   end
#
#   it '#description' do
#     expect(listing.description).to eq("Whole house for rent on mountain. Many bedrooms.")
#   end
#
#   it '#address' do
#     expect(listing.address).to eq('123 Main Street')
#   end
#
#   it '#listing type' do
#     expect(listing.listing_type).to eq("shared room")
#   end
#
#   it '#price' do
#     expect(listing.price).to eq(15.00)
#   end
#
#   it 'belongs to a neighborhood' do
#     expect(listing.neighborhood).to eq(neighborhood)
#   end
#
#   it 'belongs to a host' do
#     expect(listing.host).to eq(host)
#   end
#
#   it 'has many reservations' do
#     expect(listing.reservations).to include(reservation)
#   end
#
#   it 'has many guests' do
#     expect(listing.guests).to include(guest)
#   end
#
#   it 'has many reviews' do
#     expect(listing.reviews).to include(review)
#   end
#
#   describe 'validations' do
#     let(:invalid) { Listing.new }
#
#     it 'requires a neighborhood' do
#       expect(invalid).to have(1).error_on(:neighborhood)
#     end
#
#     it 'validates presence of :address' do
#       expect(invalid).to have(1).error_on(:address)
#     end
#
#     it 'validates presence of :description' do
#       expect(invalid).to have(1).error_on(:description)
#     end
#
#     it 'validates presence of :listing_type' do
#       expect(invalid).to have(1).error_on(:listing_type)
#     end
#
#     it 'validates presence of :price' do
#       expect(invalid).to have(1).error_on(:price)
#     end
#
#     it 'validates presence of :title' do
#       expect(invalid).to have(1).error_on(:title)
#     end
#   end
#
#   describe 'callbacks' do
#     let(:user) { User.create(name: 'user') }
#
#     it 'makes user a host when the user gets a listing' do
#       listing = Listing.create(
#         address: '123 Main Street',
#         description: "Whole house for rent on mountain. Many bedrooms.",
#         host: user,
#         listing_type: 'shared room',
#         neighborhood: neighborhood,
#         price: 15.00,
#         title: 'Beautiful Apartment on Main Street',
#       )
#
#       listing.run_callbacks(:save)
#
#       expect(user.host?).to be(true) #changed to host? to match master schema for Users
#     end
#
#     it 'makes user not a host when all listings are removed' do
#       listing1 = Listing.create(
#         address: '123 Main Street',
#         description: "Whole house for rent on mountain. Many bedrooms.",
#         host: user,
#         listing_type: 'shared room',
#         neighborhood: neighborhood,
#         price: 15.00,
#         title: 'Beautiful Apartment on Main Street',
#       )
#
#       listing2 = Listing.create(
#         address: '123 Main Street',
#         description: "Whole house for rent on mountain. Many bedrooms.",
#         host: user,
#         listing_type: 'shared room',
#         neighborhood: neighborhood,
#         price: 15.00,
#         title: 'Beautiful Apartment on Main Street',
#       )
#
#       listing1.run_callbacks(:save)
#       listing2.run_callbacks(:save)
#
#       expect(user.host?).to be(true) #changed to host? to match master schema for Users
#
#       listing2.destroy
#
#       listing2.run_callbacks(:destroy)
#
#       expect(user.host?).to be(true) #changed to host? to match master schema for Users
#
#       listing1.destroy
#
#       listing1.run_callbacks(:destroy)
#       expect(user.host?).to be(false) #changed to host? to match master schema for Users
#     end
#   end
#
#   describe "#average_review_rating" do
#     let(:reservations) do
#       [Reservation.create(
#         listing: listing,
#         checkin: 10.days.ago,
#         checkout: 5.days.ago,
#         status: 'accepted'
#       ), Reservation.create(
#          listing: listing,
#          checkin: 30.days.ago,
#          checkout: 29.days.ago,
#          status: 'accepted'
#        )]
#     end
#
#     let!(:reviews) do
#       [Review.create(
#         rating: 1,
#         description: 'foo',
#         reservation: reservations[0]
#       ), Review.create(
#          rating: 3,
#          description: 'bar',
#          reservation: reservations[1]
#        )]
#     end
#
#     it 'calculates average rating from reviews' do
#       expect(listing.average_review_rating).to eq(3)
#     end
#   end
# end

#master spec
describe Listing do
  describe 'attributes' do

    let(:listing) { Listing.new(title: 'Beautiful Apartment on Main Street',
                                description: "Whole house for rent on mountain. Many bedrooms.",
                                address: '123 Main Street',
                                listing_type: 'shared room',
                                price: 15.00) }

    it 'has a title' do
      expect(listing.title).to eq("Beautiful Apartment on Main Street")
    end

    it 'has a description' do
      expect(listing.description).to eq("Whole house for rent on mountain. Many bedrooms.")
    end

    it 'has an address' do
      expect(@listing1.address).to eq('123 Main Street')
    end

    it 'has a listing type' do
      expect(@listing2.listing_type).to eq("shared room")
    end

    it 'has a price' do
      expect(@listing2.price).to eq(15.00)
    end
  end

  describe 'belongs_to associations' do
    let(:listing) { Listing.new }
    let(:host) { User.new }
    let(:neighborhood) { Neighborhood.new }

    it 'belongs to a neighborhood' do
      listing.neighborhood = neighborhood
      expect(listing.neighborhood).to eq(neighborhood)
    end

    it 'belongs to a host' do
      listing.host = host
      expect(listing.host).to eq(host)
    end
  end

  describe 'has_many associations' do



    before :each do
      @older_reservation = Reservation.create(checkin: 10.days.ago,
                                              listing: listing,
                                              checkout: 5.days.ago, status: 'accepted')
      @recent_reservation = Reservation.create(checkin: 30.days.ago,
                                              listing: listing, checkout: 29.days.ago,
                                              status: 'accepted')
      @older_reservation.guest = bart_simpson
      @older_reservation.save
      @recent_reservation.guest = lisa_simpson
      @recent_reservation.save
      @review = Review.create(rating: 1, description: 'it was good', reservation_id: @recent_reservation.id)
      @other_review = Review.create(rating: 4, description: 'also good', reservation_id: @older_reservation.id)

      listing.reload
    end

    let(:listing) { listing = Listing.create(address: '123 Main Street',
                                            listing_type: "private room",
                                            title: "Foo",
                                            description: "Foo",
                                            price: "150.00",
                                            neighborhood: Neighborhood.create,
                                            host: User.create) }

    let(:bart_simpson) { User.create }
    let(:lisa_simpson) { User.create }

    it 'has many reservations' do
      expect(listing.reservations).to include(@older_reservation)
      expect(listing.reservations).to include(@recent_reservation)
    end

    it 'has many guests' do
      expect(listing.guests).to include(bart_simpson)
      expect(listing.guests).to include(lisa_simpson)
    end

    it 'has many reviews' do
      expect(listing.reviews).to include(@review)
    end
  end

  describe 'listing validations' do
    let(:listing) { Listing.new }

    before :each do
      listing.valid?
    end

    it 'is invalid without an address' do
      expect(listing.errors.full_messages).to include "Address can't be blank"
    end

    it 'is invalid without a listing type' do
      expect(listing.errors.full_messages).to include "Listing type can't be blank"
    end

    it 'is invalid without a title' do
      expect(listing.errors.full_messages).to include "Title can't be blank"
    end

    it 'is invalid without a description' do
      expect(listing.errors.full_messages).to include "Description can't be blank"
    end

    it 'is invalid without a price' do
      expect(listing.errors.full_messages).to include "Price can't be blank"
    end

    it 'is invalid without an associated neighborhood' do
      expect(listing.errors.full_messages).to include "Neighborhood can't be blank"
    end
  end

  describe 'callback methods' do
    let(:los_angelos) { City.create(name: "Los Angeles") }
    let(:santa_monica) { Neighborhood.create(name: 'Santa Monica', city: los_angelos) }

    context 'when listing created' do
      let(:user) { User.create(name: 'Tina Fey', host: false) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      it 'changes user host status' do
        expect(user.host?).to eq(false)

        listing = Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user)
        expect(user.reload.host?).to eq(true)
      end
    end

    context "when some of a host's listings are destroyed" do
      let(:user) { User.create(name: 'Tina Fey', host: true) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      let(:first_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:second_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:unrelated_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }

        before :each do
          first_listing
          second_listing
        end

      it 'does not change the host status to false' do
        expect(user.host?).to eq(true)
        first_listing.destroy
        expect(user.reload.host?).to eq(true)
      end
    end

    context "when all of a host's listings are destroyed" do
      let(:user) { User.create(name: 'Tina Fey', host: true) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      let(:first_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:second_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:unrelated_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }

      it 'changes host status to false' do
        expect(user.host).to eq(true)
        first_listing.destroy
        second_listing.destroy
        expect(user.reload.host?).to eq(false)
      end
    end
  end


  describe "#average_review_rating" do
    before do
      recent_reservation = Reservation.create(listing: listing, checkin: 10.days.ago, checkout: 5.days.ago, status: 'accepted')
      older_reservation = Reservation.create(listing: listing, checkin: 30.days.ago, checkout: 29.days.ago, status: 'accepted')
      review = Review.create(rating: 1, description: 'it was good', reservation_id: recent_reservation.id)
      other_review = Review.create(rating: 4, description: 'also good', reservation_id: older_reservation.id)
    end



    let(:listing) { listing = Listing.create(address: '123 Main Street',
                                            listing_type: "private room",
                                            title: "Foo",
                                            description: "Foo",
                                            price: "150.00",
                                            neighborhood: Neighborhood.create,
                                            host: User.create) }

    it 'knows its average ratings from its reviews' do
      listing.reload
      expect(listing.average_review_rating).to eq(2.5)
    end
  end
end
