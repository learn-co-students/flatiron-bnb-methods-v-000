describe Reservation do
  let(:nyc) { City.create(name: 'NYC') }
  let(:neighborhood) { Neighborhood.create(name: 'Tribeca', city: nyc) }
  let(:guest) { User.create(name: 'Guest') }
  let(:host) { User.create(name: 'Host') }
  let(:listing) do
    Listing.create(
      address: '123 Main Street',
      description: "Whole house for rent on mountain. Many bedrooms.",
      host: host,
      listing_type: 'shared room',
      neighborhood: neighborhood,
      price: 15.00,
      title: 'Beautiful Apartment on Main Street',
    )
  end
  let(:reservation) do
    Reservation.create(
      check_in: '2014-04-25',
      check_out: '2014-04-30',
      guest: guest,
      listing: listing,
      status: 'accepted'
    )
  end

  it 'has a check_in time' do
    expect(reservation.check_in).to eq(Date.parse('2014-04-25'))
  end

  it 'has a checkout time' do
    expect(reservation.check_out).to eq(Date.parse('2014-04-30'))
  end

  it 'has a status' do
    expect(reservation.status).to eq("accepted")
  end

  it 'has a default status of "pending"' do
    expect(Reservation.new.status).to eq("pending")
  end

  it 'belongs to a guest' do
    expect(reservation.guest).to eq(guest)
  end

  it 'belongs to a listing' do
    expect(reservation.listing).to eq(listing)
  end

  it 'has a review' do
    Review.create(
      description: 'good',
      guest: guest,
      rating: 5,
      reservation: reservation,
    )
    expect(reservation.review.description).to eq('good')
  end

  it 'is valid with a check_in and check_out' do
    expect(reservation).to be_valid
  end

  it 'is invalid without a check_in' do
    
    expect(
      Reservation.new(
      check_out: '2014-01-30',
      guest: guest,
      listing: listing
    )).not_to be_valid
  end

  it 'is invalid without a check_out' do
    expect(
      Reservation.new(
      check_in:  '2014-01-30',
      guest: guest,
      listing: listing
    )).not_to be_valid
  end

  it 'validates that you cannot make a reservation on your own listing' do
    expect(
      Reservation.new(
      check_in: '2014-01-30',
      check_out: '2014-02-1',
      guest: host,
      listing: listing
    )).to_not be_valid
  end

  it 'validates that check-in is before check-out' do
    expect(
      Reservation.new(
      check_in: '2014-04-21',
      check_out: '2014-04-20',
      guest: guest,
      listing: listing,
      status: 'accepted'
    )).not_to be_valid
  end

  it 'validates that check-in and check-out dates are not the same' do
    expect(
      Reservation.new(
      check_in: '2014-04-21',
      check_out: '2014-04-21',
      guest: guest,
      listing: listing,
      status: 'accepted'
    )).not_to be_valid
  end

  describe "conflicts" do
    before(:each) do
      
      Reservation.create!(
        check_in: '2014-04-25',
        check_out: '2014-04-30',
        guest: guest,
        listing: listing,
        status: 'accepted'
      )
    end

    it 'validates that a listing is available at check-in before making reservation' do

      expect(
        Reservation.new(
        check_in: '2014-04-24',
        check_out: '2014-04-26',
        guest: guest,
        listing: listing,
        status: 'accepted'
      )).not_to be_valid
    end

    it 'validates that a listing is available at check-out before making reservation' do
      expect(
        Reservation.new(
        check_in: '2014-04-20',
        check_out: '2014-04-26',
        guest: guest,
        listing: listing,
        status: 'accepted'
      )).not_to be_valid
    end

    it 'validates that a listing is available at both check-in and check-out before making reservation' do
      expect(
        Reservation.new(
        check_in: '2014-04-26',
        check_out: '2014-04-28',
        guest: guest,
        listing: listing,
        status: 'accepted'
      )).not_to be_valid
    end
  end


  describe '#duration' do
    it 'knows about its duration based on check-in and check-out dates' do
      expect(reservation.duration).to eq(5)
    end
  end

  describe '#total_price' do
    it 'knows about its total price' do
      expect(reservation.total_price).to eq(75.00)
    end
  end
end
