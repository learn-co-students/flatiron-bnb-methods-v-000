# == Schema Information
#
# Table name: reservations
#
#  id         :integer          not null, primary key
#  checkin    :date
#  checkout   :date
#  listing_id :integer
#  guest_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :string           default("pending")
#

describe Reservation do
  describe 'associations' do 
    it { should belong_to(:guest) }
    it { should belong_to(:listing) }
    it { should belong_to(:review) }
  end

  describe 'properties' do 
    let(:reservation) { FactoryGirl.create :reservation }

    it 'is valid'
      expect(reservation).to be_valid
    end

    it 'has a status, default is pending' do 
      expect(reservation.status).to eq("pending")
    end
  end

  describe 'validations' do
    let(:checkin) { 10.days.ago }
    let(:checkout) { Time.current }
    let(:reservation) { FactoryGirl.create(reservation, 
                        checkin: checkin,
                        checkout: checkout )}

      it 'requires a checkout' do 
        let(:checkin) { nil }
        expect(reservation).to_not be_valid
      end
    end

    it 'is invalid without a checkin' do
      let(:checkout) { nil }
      expect(reservation).to_not be_valid 
    end

    # Need to rewrite this
    it 'is invalid if you reserve your own listing' do 
      let(:host) { User.create(name: 'host') }
      let(:reservation) { Reservation.create(checkin: checkin, 
        checkout: checkout,
        guest: host) }
      let(:listing) { Listing.create(host: host) }
      expect(reservation).to_not be_valid
    end
  end

  describe 'availability validations' do 
    let(:listing) { Listing.create(host: host) }

    let(:existing_reservation) { Reservation.create(checkin: checkin, 
        checkout: checkout,
        guest: host, 
        listing: listing)}
      let(:checkin) { 10.days.ago }
      let(:checkout) { Time.current }

    let(:new_reservation) { Reservation.create(checkin: new_reservation_checkin, 
        checkout: new_reservation_checkout,
        guest: host, 
        listing: listing)}

    it 'is invalid if unavailable at checkin' do 
      let(:new_reservation_checkin) { checkin + 1.day }
      expect(new_reservation).to_not be_valid
    end

    it 'is invalid if unavailable at checkout' do 
      let(:new_reservation_checkout) { checkin - 1.day }

      expect(new_reservation).to_not be_valid
    end

    it 'is invalid if checkout is before checkin' do 
      let(:new_reservation_checkout) { 10.days.ago } 
      let(:new_reservation_checkin) { Time.current }

      expect(new_reservation).to_not be_valid
    end

    it 'is invalid if checkin date is the same as checkout date' do 
      let(:new_reservation_checkin) { Time.current }
      let(:new_reservation_checkout) { new_reservation_checkin + 1.hour } 
      expect(new_reservation).to_not be_valid
    end
  end

  
  let(:reservation) { Reservation.create(checkin: checkin, 
      checkout: checkout,
      guest: host, 
      listing: listing)}

    describe "#length_of_current_stay" do
      let(:checkin) { 5.days.ago }
      let(:checkout) { Time.current }

      it 'returns length of current stay in days' do
        expect(reservation.duration).to eq(5) 
      end
    end

    describe "#total_price" do
      let(:checkin) { 5.days.ago }
      let(:checkout) { Time.current }
      let(:listing) { Listing.create(host: host, price: 50) }

      it 'knows about its total price' do
        expect(reservation.total_price).to eq(250.00) 
      end
    end
  end
end
