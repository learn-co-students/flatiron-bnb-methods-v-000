require 'rails_helper'

describe Review do
  describe 'associations' do
    it 'has a description' do
      expect(@review1.description).to eq("This place was great!") 
    end

    it 'has a rating' do
      expect(@review1.rating).to eq(5) 
    end

    it 'belongs to a guest' do
      expect(@review1.guest).to eq(@logan) 
    end

    it 'belongs to a reservation' do
      expect(@review1.reservation).to eq(@reservation1) 
    end
  end

  describe 'review validations' do
    before(:each) do 
      @invalidrating = Review.new(:description => "hi", :rating => nil)
      @invaliddescription = Review.new(:description => nil, :rating => 5)
    end

    it 'is valid with a rating and description' do
      expect(@review1).to be_valid 
    end

    it 'is invalid without a rating' do 
      expect(@invalidrating).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(@invaliddescription).to_not be_valid 
    end

    it 'is invalid without an associated reservation' do 
      no_res = Review.create(description: "Meh", rating: 2, guest_id: User.find_by(id: 6).id)
      expect(no_res).to_not be_valid
    end
  end
end
