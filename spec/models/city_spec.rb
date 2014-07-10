require 'rails_helper'

describe City do
  describe 'associations' do 
    it 'has a name' do 
      expect(City.first.name).to eq('NYC')
    end

    it 'has many neighborhoods' do 
      expect(City.first.neighborhoods).to eq([@nabe1, @nabe2, @nabe3])
    end
  end

  describe 'instance methods' do
    xit 'knows about all the available listings given a date range' do 
    end 
  end

  describe 'class methods' do
    xit 'knows the city with the highest ratio of reservations to listings' do 
    end

    xit 'knows the city with the most reservations' do 
    end 
  end
end
