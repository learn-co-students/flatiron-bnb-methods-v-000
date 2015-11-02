# == Schema Information
#
# Table name: neighborhoods
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

describe Neighborhood do
  describe 'associations' do    
    it { should belong_to(:city) }
    it { should have_many(:listings) }

    it 'is valid' do 
      expect(FactoryGirl.create :neighborhood).to be_valid
    end
  end

  describe '#neighborhood_openings' do
    let(:neighborhood) { FactoryGirl.create(:neighborhood) }
    let(:available_listing) { FactoryGirl.create :listing, neighborhood: neighborhood }
    let(:unavailable_listing) { FactoryGirl.create :listing, neighborhood: neighborhood }
    let(:reservation) { FactoryGirl.create :reservation, 
                        listing: unavailable_listing,
                        checkin: '2014-05-01',
                        checkout: '2014-05-30' }
    before do 
      neighborhood
      available_listing
      unavailable_listing
      reservation
    end

    it 'returns available listings for the date range' do
      expect(neighborhood.available_listings_from('2014-05-01', '2014-05-30')).to include(available_listing) 
    end 

    it 'does not return unavailable listings' do 
      expect(neighborhood.available_listings_from('2014-05-01', '2014-05-30')).to_not include(unavailable_listing) 
    end
  end

  describe 'class methods' do
    let(:manhattan) { FactoryGirl.create(:neighborhood, name: 'Manhattan') }
    let(:bronx) { FactoryGirl.create(:neighborhood, name: 'Bronx') }

    let(:bronx_listing) { FactoryGirl.create :listing, neighborhood: bronx }

    before :each do 
      5.times do |i|
        listing = FactoryGirl.create(:listing, neighborhood: manhattan)
        FactoryGirl.create(:reservation, listing: listing)
      end

      4.times do |i|
        FactoryGirl.create(:reservation, listing: bronx_listing)
      end
    end 

    describe ".most_reservations_per_listings" do
      it 'returns the neighborhood with the highest ratio of reservations to listings' do 
        expect(Neighborhood.most_reservations_per_listing).to eq(bronx)
      end
    end

    describe ".most_reservations" do
      it 'knows the neighborhood with the most reservations' do 
        expect(Neighborhood.most_reservations).to eq(manhattan)
      end
    end 
  end
end
