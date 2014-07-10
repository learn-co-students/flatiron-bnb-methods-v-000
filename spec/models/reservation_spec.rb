require 'rails_helper'

describe Reservation do
  describe 'associations' do 
    it 'has a checkin time' do 
      expect(@reservation1.checkin).to eq(Date.parse('2014-04-25'))
    end

    it 'has a checkout time' do
      expect(@reservation1.checkout).to eq(Date.parse('2014-04-30')) 
    end

    it 'has a status, default is pending' do 
      expect(@reservation3.status).to eq("pending")
    end

    it 'belongs to a guest' do 
      expect(@reservation1.guest).to eq(@logan)
    end

    it 'belongs to a listing' do
    expect(@reservation1.listing).to eq(@listing1)
    end
  end

  describe 'reservation validations' do
    before(:each) do 
      @invalidcheckin = Reservation.new(checkin: nil, checkout: '2014-01-30', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
      @invalidcheckout = Reservation.new(checkin:  '2014-01-30', checkout: nil, guest_id: User.find_by(id: 5).id, listing_id: Listing.find_by(id: 2).id)
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

    xit 'validates that you cannot make a reservation on your own listing' do 
    end

    xit 'validates that a listing is available before making reservation' do 
    end
  end

  describe 'instance methods' do
    it 'knows about its duration based on checkin and checkout dates' do
      expect(@reservation1.duration).to eq(5) 
    end

    it 'knows about its total price' do
      expect(@reservation1.total_price).to eq(250.00) 
    end
  end
end