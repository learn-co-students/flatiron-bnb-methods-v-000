# == Schema Information
#
# Table name: listings
#
#  id              :integer          not null, primary key
#  address         :string
#  listing_type    :string
#  title           :string
#  description     :text
#  price           :decimal(8, 2)
#  neighborhood_id :integer
#  host_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

describe Listing do
  describe 'attributes' do

    it 'should have be valid' do 
      expect(FactoryGirl.create :listing).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:reservations) }
    it { should have_many(:guests) }
    it { should have_many(:reviews) }
    it { should belong_to(:neighborhood) }
    it { should belong_to(:host) }
  end

  describe 'listing validations' do
    let(:listing) { Listing.new }

    before :each do
      listing.valid?
    end

    it 'is invalid without an address' do
      expect(listing.errors.full_messages).to include "Address can't be blank"
    end

    it 'is invalid without a listing type' do
      expect(listing.errors.full_messages).to include "Listing type can't be blank"
    end

    it 'is invalid without a title' do
      expect(listing.errors.full_messages).to include "Title can't be blank"
    end

    it 'is invalid without a description' do
      expect(listing.errors.full_messages).to include "Description can't be blank"
    end

    it 'is invalid without a price' do
      expect(listing.errors.full_messages).to include "Price can't be blank"
    end

    it 'is invalid without an associated neighborhood' do 
      expect(listing.errors.full_messages).to include "Neighborhood can't be blank"
    end
  end

  # Instead of the callback methods, 
  # there should just be a method that says, is currently hosting?

  # describe 'callback methods' do
  #   let(:los_angelos) { City.create(name: "Los Angeles") }
  #   let(:santa_monica) { Neighborhood.create(name: 'Santa Monica', city: los_angelos) }

  #   context 'when listing created' do
  #     let(:user) { User.create(name: 'Tina Fey', host: false) }
  #     let(:other_user) { User.create(name: 'Not Tina Fey') }

  #     it 'changes user host status' do
  #       expect(user.host?).to eq(false)

  #       let(:listing) { FactoryGirl.create(:listing,
  #         neighborhood: santa_monica,
  #         host: user) }
  #       expect(user.reload.host?).to eq(true)
  #     end
  #   end

    # context "when some of a host's listings are destroyed" do
    #   let(:user) { User.create(name: 'Tina Fey', host: true) }
    #   let(:other_user) { User.create(name: 'Not Tina Fey') }

    #   let(:first_listing) { Listing.create(address: '123 Main Street',
    #       listing_type: "private room",
    #       title: "Foo",
    #       description: "Foo",
    #       price: "150.00",
    #       neighborhood: santa_monica,
    #       host: user) }
    #     let(:second_listing) { Listing.create(address: '123 Main Street',
    #       listing_type: "private room",
    #       title: "Foo",
    #       description: "Foo",
    #       price: "150.00",
    #       neighborhood: santa_monica,
    #       host: user) }
    #     let(:unrelated_listing) { Listing.create(address: '123 Main Street',
    #       listing_type: "private room",
    #       title: "Foo",
    #       description: "Foo",
    #       price: "150.00",
    #       neighborhood: santa_monica,
    #       host: user) }

    #     before :each do 
    #       first_listing
    #       second_listing
    #     end

    #   it 'does not change the host status to false' do
    #     expect(user.host?).to eq(true)
    #     first_listing.destroy
    #     expect(user.reload.host?).to eq(true)
    #   end
    # end

  #   context "when all of a host's listings are destroyed" do
  #     let(:user) { User.create(name: 'Tina Fey', host: true) }
  #     let(:other_user) { User.create(name: 'Not Tina Fey') }

  #     let(:first_listing) { FactoryGirl.create :listing,
  #         neighborhood: santa_monica,
  #         host: user) }
  #       let(:second_listing) { Listing.create(address: '123 Main Street', 
  #         listing_type: "private room", 
  #         title: "Foo", 
  #         description: "Foo", 
  #         price: "150.00", 
  #         neighborhood: santa_monica, 
  #         host: user) } 
  #       let(:unrelated_listing) { Listing.create(address: '123 Main Street', 
  #         listing_type: "private room", 
  #         title: "Foo", 
  #         description: "Foo", 
  #         price: "150.00", 
  #         neighborhood: santa_monica, 
  #         host: user) } 

  #     it 'changes host status to false' do 
  #       expect(user.host).to eq(true)
  #       first_listing.destroy
  #       second_listing.destroy
  #       expect(user.reload.host?).to eq(false)
  #     end
  #   end
  # end

  describe '#number_of_reservations' do
    let(:listing) { Listing.create(address: '11 broadway', 
                    listing_type: 'school', 
                    title: 'Flatiron', 
                    description: 'Learn love code.',
                    price: 'Priceless', 
                    neighborhood: Neighborhood.create,
                    host: User.create) }
    
    before do
      Reservation.create(listing: listing)
      Reservation.create(listing: listing)
    end
    
    it 'resturns the number of reservations' do
      expect(listing.number_of_reservations).to eq 2
    end
  end

  describe "#average_review_rating" do
    let(:first_review) { Review.create(rating: 1) }
    let(:second_review) { Review.create(rating: 2) }
    let(:listing) { FactoryGirl.create :listing }
    before do 
        reservation_two = FactoryGirl.create(:reservation, listing: listing)
        FactoryGirl.create(:review, reservation: reservation_two, rating: 3)

        reservation_one = FactoryGirl.create(:reservation, listing: listing)
        FactoryGirl.create(:review, reservation: reservation_one, rating: 5)
      end

    it 'calculates its average rating' do
      expect(listing.average_review_rating).to eq(4)
    end
  end

  describe '#available_from?' do
    let(:city) { City.create(name: 'NYC') }
    let(:vacation)    { Reservation.create(checkin: reservation_begin_date, checkout: reservation_end_date)}
    let(:staycation)  { Reservation.create }
    let(:listing) { Listing.create(title: 'Beautiful Apartment on Main Street',
                                description: "Whole house for rent on mountain. Many bedrooms.",
                                neighborhood: Neighborhood.new,
                                address: '123 Main Street',
                                listing_type: 'shared room',
                                price: 15.00,
                                reservations: [vacation, staycation],
                                host: User.new) }

    context 'when a listing has any reservations that start before or on the beginning_date' do     
      context 'and end after the beginning date' do
        #  KEY ^ => beginning date, $ => end_date
        #
        #               ^------------------$
        #                 available_from?
        #           |-------------|
        #             reservation
        let(:reservation_begin_date) { Time.parse(query_begin_date) - 5.days }
        let(:reservation_end_date) { Time.parse(query_begin_date)  + 5.days }
        let(:query_begin_date) { '2014-05-01' }
        let(:query_end_date) { '2014-05-05' }

        it 'returns false' do

          expect(listing.available_from?(query_begin_date, query_end_date)).to eq false
        end
      end

      context 'and ends before or on the beginning date' do
        #  KEY ^ => beginning date, $ => end_date
        #
        #                       ^----------------$
        #                         available_from?
        #     |-------------|
        #       reservation 

        let(:reservation_begin_date) { Time.parse(query_begin_date) - 5.days }
        let(:reservation_end_date) { Time.parse(query_begin_date)  - 1.days }
        let(:query_begin_date) { '2014-05-01' }
        let(:query_end_date) { '2014-05-05' }

        it 'returns true' do
          expect(listing.available_from?(query_begin_date, query_end_date))
        end
      end
    end

    context 'when a listing has reservations that start on or after the end_date' do
      #  KEY ^ => beginning date, $ => end_date
      #
      #    ^------------------$
      #       available_from?
      #                           |-------------|
      #                             reservation


      let(:reservation_begin_date) { Time.parse(query_begin_date) - 5.days }
      let(:reservation_end_date) { Time.parse(query_begin_date)  - 1.days }
      let(:query_begin_date) { '2014-05-01' }
      let(:query_end_date) { '2014-05-05' }

      it 'returns true' do
        expect(listing.available_from?(query_begin_date, query_end_date))
      end
    end

    context 'when a listing has reservations that start after the beginning date' do
      context 'and before the end date' do
        #  KEY ^ => beginning date, $ => end_date
        #
        #    ^------------------$
        #       available_from?
        #                   |-------------|
        #                      reservation

        let(:reservation_begin_date) { Time.parse(query_end_date) - 1.days }
        let(:reservation_end_date) { Time.parse(query_end_date) + 1.days }
        let(:query_begin_date) { '2014-05-01' }
        let(:query_end_date) { '2014-05-05' }

        it 'returns false' do
          expect(listing.available_from?(query_begin_date, query_end_date))
        end
      end

      context 'and after the end date' do
        #  KEY ^ => beginning date, $ => end_date
        #
        #    ^------------------$
        #       available_from?
        #                            |-------------|
        #                              reservation

        let(:reservation_begin_date) { Time.parse(query_begin_date) - 5.days }
        let(:reservation_end_date) { Time.parse(query_begin_date) - 2.days }
        let(:query_begin_date) { '2014-05-01' }
        let(:query_end_date) { '2014-05-05' }

        it 'returns true' do
          expect(listing.available_from?(query_begin_date, query_end_date))
        end
      end
    end
  end 
end
