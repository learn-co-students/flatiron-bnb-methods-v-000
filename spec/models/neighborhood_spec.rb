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
      expect(@nabe3.listings).to eq([@listing3])
    end
  end

  describe 'model methods' do 
  end
end
