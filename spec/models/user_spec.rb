require 'rails_helper'

describe User do
  describe 'associations' do
    it 'has a name' do
      expect(@katie.name).to eq("Katie") 
    end

    it 'as a host has many listings' do
      expect(@amanda.listings).to eq([@listing1]) 
    end

    it 'as a guest has many reservations' do
      expect(@tristan.reservations).to eq([@reservation2])
    end

    it 'as a guest has written many reviews' do
      expect(@avi.reviews).to eq([@review3])
    end
  end

  describe 'model methods' do 
  end
end
