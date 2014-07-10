require 'rails_helper'

describe Listing do
  describe 'associations' do
    it 'has a title' do 
      expect(@listing1.title).to eq("Beautiful Apartment on Main Street")
    end

    it 'has a description' do
      expect(@listing3.description).to eq("Whole house for rent on mountain. Many bedrooms.")
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

    it 'belongs to a neighborhood' do 
      expect(@listing2.neighborhood.name).to eq('Green Point')
    end

    it 'belongs to a host' do 
      expect(@listing2.host.name).to eq('Katie')
    end

    it 'has many reviews' do 
      expect(@listing3.reviews).to include(@review3)
    end

    it 'has many reservations' do
      expect(@listing3.reservations).to include(@reservation3)
    end

    it 'knows about all of its guests' do 
      expect(@listing3.guests).to include(@avi)
    end
  end

  describe 'model methods' do 
  end
end
