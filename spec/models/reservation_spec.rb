# solution spec -- updated to replace check_in, check_out
# describe Reservation do
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
#   let(:reservation) do
#     Reservation.create(
#       checkin: '2014-04-25',
#       checkout: '2014-04-30',
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )
#   end
#
#   it 'has a checkin time' do
#     expect(reservation.checkin).to eq(Date.parse('2014-04-25'))
#   end
#
#   it 'has a checkout time' do
#     expect(reservation.checkout).to eq(Date.parse('2014-04-30'))
#   end
#
#   it 'has a status' do
#     expect(reservation.status).to eq("accepted")
#   end
#
#   it 'has a default status of "pending"' do
#     expect(Reservation.new.status).to eq("pending")
#   end
#
#   it 'belongs to a guest' do
#     expect(reservation.guest).to eq(guest)
#   end
#
#   it 'belongs to a listing' do
#     expect(reservation.listing).to eq(listing)
#   end
#
#   it 'has a review' do
#     Review.create(
#       description: 'good',
#       guest: guest,
#       rating: 5,
#       reservation: reservation,
#     )
#     expect(reservation.review.description).to eq('good')
#   end
#
#   it 'is valid with a checkin and checkout' do
#     expect(reservation).to be_valid
#   end
#
#   it 'is invalid without a checkin' do
#
#     expect(
#       Reservation.new(
#       checkout: '2014-01-30',
#       guest: guest,
#       listing: listing
#     )).not_to be_valid
#   end
#
#   it 'is invalid without a checkout' do
#     expect(
#       Reservation.new(
#       checkin:  '2014-01-30',
#       guest: guest,
#       listing: listing
#     )).not_to be_valid
#   end
#
#   it 'validates that you cannot make a reservation on your own listing' do
#     expect(
#       Reservation.new(
#       checkin: '2014-01-30',
#       checkout: '2014-02-1',
#       guest: host,
#       listing: listing
#     )).to_not be_valid
#   end
#
#   it 'validates that check-in is before check-out' do
#     expect(
#       Reservation.new(
#       checkin: '2014-04-21',
#       checkout: '2014-04-20',
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )).not_to be_valid
#   end
#
#   it 'validates that check-in and check-out dates are not the same' do
#     expect(
#       Reservation.new(
#       checkin: '2014-04-21',
#       checkout: '2014-04-21',
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )).not_to be_valid
#   end
#
#   describe "conflicts" do
#     before(:each) do
#
#       Reservation.create!(
#         checkin: '2014-04-25',
#         checkout: '2014-04-30',
#         guest: guest,
#         listing: listing,
#         status: 'accepted'
#       )
#     end
#
#     it 'validates that a listing is available at check-in before making reservation' do
#
#       expect(
#         Reservation.new(
#         checkin: '2014-04-24',
#         checkout: '2014-04-26',
#         guest: guest,
#         listing: listing,
#         status: 'accepted'
#       )).not_to be_valid
#     end
#
#     it 'validates that a listing is available at check-out before making reservation' do
#       expect(
#         Reservation.new(
#         checkin: '2014-04-20',
#         checkout: '2014-04-26',
#         guest: guest,
#         listing: listing,
#         status: 'accepted'
#       )).not_to be_valid
#     end
#
#     it 'validates that a listing is available at both check-in and check-out before making reservation' do
#       expect(
#         Reservation.new(
#         checkin: '2014-04-26',
#         checkout: '2014-04-28',
#         guest: guest,
#         listing: listing,
#         status: 'accepted'
#       )).not_to be_valid
#     end
#   end
#
#
#   describe '#duration' do
#     it 'knows about its duration based on check-in and check-out dates' do
#       expect(reservation.duration).to eq(5)
#     end
#   end
#
#   describe '#total_price' do
#     it 'knows about its total price' do
#       expect(reservation.total_price).to eq(75.00)
#     end
#   end
# end

# master spec
describe Reservation do
  describe 'associations' do
    it 'has a checkin time' do
      expect(@reservation1.checkin).to eq(Date.parse('2014-04-25'))
    end

    it 'has a checkout time' do
      expect(@reservation1.checkout).to eq(Date.parse('2014-04-30'))
    end

    it 'has a status, default is pending' do
      expect(@reservation3.status).to eq("accepted")
    end

    it 'belongs to a guest' do
      expect(@reservation1.guest).to eq(@logan)
    end

    it 'belongs to a listing' do
    expect(@reservation1.listing).to eq(@listing1)
    end

    it 'has a review' do
      expect(@reservation1.review).to eq(@review1)
    end
  end

  describe 'reservation validations' do
    before(:each) do
      @invalidcheckin = Reservation.new(checkout: '2014-01-30', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalidcheckout = Reservation.new(checkin:  '2014-01-30', guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)
      @invalid_same_ids = Reservation.new(checkin: '2014-04-25', checkout: '2014-04-30', listing_id: 1, guest_id: 1)
      @invalid_checkin = Reservation.new(checkin: '2014-04-26', checkout: '2014-05-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_checkout = Reservation.new(checkin: '2014-04-20', checkout: '2014-04-26', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_checkin_checkout = Reservation.new(checkin:  '2014-04-26', checkout: '2014-04-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_checkout_before_checkin = Reservation.new(checkin:  '2014-05-23', checkout: '2014-05-20', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_same_checkout_checkin = Reservation.new(checkin:  '2014-05-23', checkout: '2014-05-23', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
    end

    it 'is valid with a checkin and checkout' do
      expect(@reservation1).to be_valid
    end

    it 'is invalid without a checkin' do
      expect(@invalidcheckin).to_not be_valid
    end

    it 'is invalid without a checkout' do
      expect(@invalidcheckout).to_not be_valid
    end

    it 'validates that you cannot make a reservation on your own listing' do
      expect(@invalid_same_ids).to_not be_valid
    end

    it 'validates that a listing is available at checkin before making reservation' do
      #binding.pry
      expect(@invalid_checkin).to_not be_valid
    end

    it 'validates that a listing is available at checkout before making reservation' do
      expect(@invalid_checkout).to_not be_valid
    end

    it 'validates that a listing is available at for both checkin and checkout before making reservation' do
      expect(@invalid_checkin_checkout).to_not be_valid
    end

    it 'validates that checkin is before checkout' do
      expect(@invalid_checkout_before_checkin).to_not be_valid
    end

    it 'validates that checkin and checkout dates are not the same' do
      expect(@invalid_same_checkout_checkin).to_not be_valid
    end
  end

  describe 'instance methods' do
    describe "#duration" do
      it 'knows about its duration based on checkin and checkout dates' do
        expect(@reservation1.duration).to eq(5)
      end
    end
    describe "#total_price" do
      it 'knows about its total price' do
        expect(@reservation1.total_price).to eq(250.00)
      end
    end
  end
end
