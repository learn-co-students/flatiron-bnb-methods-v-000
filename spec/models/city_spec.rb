describe City do

  describe 'associations and validations' do 
    it 'should be valid' do 
      expect(FactoryGirl.create(:city)).to be_valid
    end
    
    it { should have_many(:neighborhoods)}
  end
  
  describe 'class methods' do
      let(:new_york) { FactoryGirl.create(:city, name: 'New York') }
      let(:philadelphia) { FactoryGirl.create(:city, name: 'Philadelphia') }

      let(:new_york_listing_one) { FactoryGirl.create :listing, neighborhood: FactoryGirl.create(:neighborhood, 
        name: 'Queens', 
        city: new_york)}
      let(:new_york_listing_two) { FactoryGirl.create :listing, neighborhood: FactoryGirl.create(:neighborhood, 
        name: 'Brooklyn', 
        city: new_york)}

      let(:philadelphia_listing) { FactoryGirl.create :listing, neighborhood: FactoryGirl.create(:neighborhood, 
        name: 'Upper Darby', 
        city: philadelphia)}

    before :each do 
      5.times do |i|
        listing = FactoryGirl.create(:listing, neighborhood: FactoryGirl.create(:neighborhood, 
          name: 'Queens', 
          city: new_york))
        FactoryGirl.create(:reservation, 
                            listing: listing)
      end

      4.times do |i|
        FactoryGirl.create(:reservation, listing: philadelphia_listing)
      end
    end 
       
    describe ".most_reservations" do
      it 'returns the city with the most reservations' do
        expect(City.most_reservations).to eq(new_york) 
      end 
    end

    describe ".most_reservations_per_listings" do
      it 'returns the city with the highest ratio of reservations to listings' do
        expect(City.most_reservations_per_listing).to eq(philadelphia) 
      end
    end
  end
end
