require 'rails_helper'

describe City do
  it 'has a name' do 
    expect(City.first.name).to eq('NYC')
  end

  it 'has many neighborhoods' do 
    expect(City.first.neighborhoods).to eq([@nabe1, @nabe2, @nabe3])
  end
end
