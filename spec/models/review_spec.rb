# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  description    :text
#  rating         :integer
#  guest_id       :integer
#  reservation_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

describe Review do
  describe 'associations' do
    it { should belong_to(:guest) }
    it { should belong_to(:reservation) }
  end

  describe 'review validations' do
    it 'is valid' do 
      expect(Review.new(description: 'stuff', rating: 'rating')).to_not raise_error
    end    

    it 'is invalid without a rating' do 
      expect(@invalidrating).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(@invaliddescription).to_not be_valid 
    end

    it 'is invalid without an associated reservation, that has been accepted, and checkout has happened' do 
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
