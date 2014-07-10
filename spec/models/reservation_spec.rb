require 'rails_helper'

describe Reservation do
  describe 'associations' do 
    it 'has a checkin time' do 
      expect(@reservation1.checkin).to eq(Date.parse('2014-04-25'))
    end

    it 'has a checkout time' do
      expect(@reservation1.checkout).to eq(Date.parse('2014-04-30')) 
    end

    it 'belongs to a guest' do 
      expect(@reservation1.guest).to eq(@logan)
    end

    it 'belongs to a listing' do
    expect(@reservation1.listing).to eq(@listing1)
    end
  end
end