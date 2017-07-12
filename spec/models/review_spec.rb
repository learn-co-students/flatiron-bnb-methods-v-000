#solution spec, updated for checkin/checkout
# describe Review do
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
#   let(:review) do
#     Review.create(
#       description: 'baller',
#       guest: guest,
#       rating: 5,
#       reservation: reservation
#     )
#   end
#
#   it 'has a description' do
#     expect(review.description).to eq("baller")
#   end
#
#   it 'has a rating' do
#     expect(review.rating).to eq(5)
#   end
#
#   it 'belongs to a guest' do
#     expect(review.guest).to eq(guest)
#   end
#
#   it 'belongs to a reservation' do
#     expect(review.reservation).to eq(reservation)
#   end
#
#   it 'is valid with a rating and description' do
#     expect(review).to be_valid
#   end
#
#   it 'is invalid without a rating' do
#     expect(Review.new(description: 'foo', guest: guest, reservation: reservation)).not_to be_valid
#   end
#
#   it 'is invalid without a description' do
#     expect(Review.new(guest: guest, rating: 4, reservation: reservation)).not_to be_valid
#   end
#
#   it 'is invalid without a reservation' do
#     expect(Review.new(description: 'foo', guest: guest, rating: 2)).not_to be_valid
#   end
#
#   it 'is invalid unless reservation is accepted' do
#     r = Reservation.create(
#       checkin: '2014-04-25',
#       checkout: '2014-04-30',
#       guest: guest,
#       listing: listing
#     )
#
#     expect(
#       Review.new(
#       description: 'foo',
#       guest: guest,
#       rating: 4,
#       reservation: r
#     )).not_to be_valid
#   end
#
#   it 'is invalid unless its reservation has ended' do
#     r = Reservation.create(
#       checkin: Date.today - 1.day,
#       checkout: Date.today + 1.day,
#       guest: guest,
#       listing: listing,
#       status: 'accepted'
#     )
#
#     expect(
#       Review.new(
#       description: 'foo',
#       guest: guest,
#       rating: 4,
#       reservation: r
#     )).not_to be_valid
#   end
# end

#master spec
describe Review do
  describe 'associations' do
    it 'has a description' do
      expect(@review1.description).to eq("This place was great!")
    end

    it 'has a rating' do
      expect(@review1.rating).to eq(5)
    end

    it 'belongs to a guest' do
      expect(@review1.guest).to eq(@logan)
    end

    it 'belongs to a reservation' do
      expect(@review1.reservation).to eq(@reservation1)
    end
  end

  describe 'review validations' do
    before(:each) do
      @invalidrating = Review.new(:description => "hi", :rating => nil)
      @invaliddescription = Review.new(:description => nil, :rating => 5)
    end

    it 'is valid with a rating and description' do
      expect(@review1).to be_valid
    end

    it 'is invalid without a rating' do
      expect(@invalidrating).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(@invaliddescription).to_not be_valid
    end

    it 'is invalid without an associated reservation, has been accepted, and checkout has happened' do
      no_res = Review.create(description: "Meh", rating: 2, guest_id: User.find_by(id: 6).id)
      res = Reservation.create(checkin: '2014-04-05', checkout: '2014-04-29', listing_id: 1, guest_id: 5, :status => "pending")
      new_res = Reservation.create(checkin: '2014-08-01', checkout: Date.today + 1, listing_id: 1, guest_id: 5, :status => "accepted")
      res_not_accepted = Review.create(description: "Hi!", rating: 3, guest_id: User.find_by(id: 5).id, reservation_id: res.id)
      res_not_passed = Review.create(description: "Hi!", rating: 3, guest_id: User.find_by(id: 5).id, reservation_id: new_res.id)
      expect(no_res).to_not be_valid
      expect(res_not_accepted).to_not be_valid
      expect(res_not_passed).to_not be_valid
    end
  end
end
