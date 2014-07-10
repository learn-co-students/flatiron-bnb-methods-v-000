require 'rails_helper'

describe Review do
  it 'has a description' do
    expect(@review1.description).to eq("This place was great!") 
  end

  it 'has a rating' do
    expect(@review1.rating).to eq(5) 
  end

  it 'belongs to a guest' do
    expect(@review1.guest).to eq(@logan) 
  end

  it 'belongs to a listing' do
    expect(@review1.listing).to eq(@listing1) 
  end

end
