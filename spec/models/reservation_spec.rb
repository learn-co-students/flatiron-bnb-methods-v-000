describe Reservation do
  describe 'associations' do
    it 'has a check_in time' do
      expect(@reservation1.check_in).to eq(Date.parse('2014-04-25'))
    end

    it 'has a check_out time' do
      expect(@reservation1.check_out).to eq(Date.parse('2014-04-30'))
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
      @invalidcheck_in = Reservation.new(check_out: '2014-01-30', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalidcheck_out = Reservation.new(check_in:  '2014-01-30', guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)
      @invalid_same_ids = Reservation.new(check_in: '2014-04-25', check_out: '2014-04-30', listing_id: 1, guest_id: 1)
      @invalid_check_in = Reservation.new(check_in: '2014-04-26', check_out: '2014-05-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_check_out = Reservation.new(check_in: '2014-04-20', check_out: '2014-04-26', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_check_in_check_out = Reservation.new(check_in:  '2014-04-26', check_out: '2014-04-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_check_out_before_check_in = Reservation.new(check_in:  '2014-05-23', check_out: '2014-05-20', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalid_same_check_out_check_in = Reservation.new(check_in:  '2014-05-23', check_out: '2014-05-23', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
    end

    it 'is valid with a check_in and check_out' do
      expect(@reservation1).to be_valid
    end

    it 'is invalid without a check_in' do
      expect(@invalidcheck_in).to_not be_valid
    end

    it 'is invalid without a check_out' do
      expect(@invalidcheck_out).to_not be_valid
    end

    it 'validates that you cannot make a reservation on your own listing' do
      expect(@invalid_same_ids).to_not be_valid
    end

    it 'validates that a listing is available at check_in before making reservation' do
      expect(@invalid_check_in).to_not be_valid
    end

    it 'validates that a listing is available at check_out before making reservation' do
      expect(@invalid_check_out).to_not be_valid
    end

    it 'validates that a listing is available at for both check_in and check_out before making reservation' do
      expect(@invalid_check_in_check_out).to_not be_valid
    end

    it 'validates that check_in is before check_out' do
      expect(@invalid_check_out_before_check_in).to_not be_valid
    end

    it 'validates that check_in and check_out dates are not the same' do
      expect(@invalid_same_check_out_check_in).to_not be_valid
    end
  end

  describe 'instance methods' do
    describe "#duration" do
      it 'knows about its duration based on check_in and check_out dates' do
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
