require 'rails_helper'

describe Neighborhood do
  describe 'associations' do
    it 'has a name' do
      expect(@nabe3.name).to eq('Brighton Beach')
    end

    it 'belongs to a city' do 
      expect(@nabe3.city.name).to eq('NYC')
    end

    it 'has many listings' do 
      expect(@nabe3.listings).to include(@listing3)
    end
  end

  describe 'instance methods' do
    xit 'knows about all the available listings given a date range' do 
    end 
  end

  describe 'class methods' do
    xit 'knows the neighborhood with the highest ratio of reservations to listings' do 
    end

    xit 'knows the neighborhood with the most reservations' do 
    end 
  end
end
