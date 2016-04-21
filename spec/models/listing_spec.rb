describe Listing do
  let(:city) { City.create(name: 'San Francisco') }
  let(:neighborhood) { Neighborhood.create(name: 'Lower Haight', city: city) }
  let(:host) { User.create(name: 'Host') }
  let(:guest) { User.create(name: 'Guest') }

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
      check_in: '2015-04-03',
      check_out: '2015-04-07',
      guest: guest,
      listing: listing,
      status: 'accepted'
    )
  end

  let!(:review) do
    Review.create(
      description: "This place was great!",
      rating: 5,
      guest: guest,
      reservation: reservation
    )
  end

  it '#title' do
    expect(listing.title).to eq("Beautiful Apartment on Main Street")
  end

  it '#description' do
    expect(listing.description).to eq("Whole house for rent on mountain. Many bedrooms.")
  end

  it '#address' do
    expect(listing.address).to eq('123 Main Street')
  end

  it '#listing type' do
    expect(listing.listing_type).to eq("shared room")
  end

  it '#price' do
    expect(listing.price).to eq(15.00)
  end

  it 'belongs to a neighborhood' do
    expect(listing.neighborhood).to eq(neighborhood)
  end

  it 'belongs to a host' do
    expect(listing.host).to eq(host)
  end

  it 'has many reservations' do
    expect(listing.reservations).to include(reservation)
  end

  it 'has many guests' do
    expect(listing.guests).to include(guest)
  end

  it 'has many reviews' do
    expect(listing.reviews).to include(review)
  end

  describe 'validations' do
    let(:invalid) { Listing.new }

    it 'requires a neighborhood' do
      expect(invalid).to have(1).error_on(:neighborhood)
    end

    it 'validates presence of :address' do
      expect(invalid).to have(1).error_on(:address)
    end

    it 'validates presence of :description' do
      expect(invalid).to have(1).error_on(:description)
    end

    it 'validates presence of :listing_type' do
      expect(invalid).to have(1).error_on(:listing_type)
    end

    it 'validates presence of :price' do
      expect(invalid).to have(1).error_on(:price)
    end

    it 'validates presence of :title' do
      expect(invalid).to have(1).error_on(:title)
    end
  end

  describe 'callbacks' do
    let(:user) { User.create(name: 'user') }

    it 'makes user a host when the user gets a listing' do
      listing = Listing.create(
        address: '123 Main Street',
        description: "Whole house for rent on mountain. Many bedrooms.",
        host: user,
        listing_type: 'shared room',
        neighborhood: neighborhood,
        price: 15.00,
        title: 'Beautiful Apartment on Main Street',
      )

      listing.run_callbacks(:save)

      expect(user.is_host?).to be(true)
    end

    it 'makes user not a host when all listings are removed' do
      listing1 = Listing.create(
        address: '123 Main Street',
        description: "Whole house for rent on mountain. Many bedrooms.",
        host: user,
        listing_type: 'shared room',
        neighborhood: neighborhood,
        price: 15.00,
        title: 'Beautiful Apartment on Main Street',
      )

      listing2 = Listing.create(
        address: '123 Main Street',
        description: "Whole house for rent on mountain. Many bedrooms.",
        host: user,
        listing_type: 'shared room',
        neighborhood: neighborhood,
        price: 15.00,
        title: 'Beautiful Apartment on Main Street',
      )

      listing1.run_callbacks(:save)
      listing2.run_callbacks(:save)

      expect(user.is_host?).to be(true)

      listing2.destroy

      listing2.run_callbacks(:destroy)

      expect(user.is_host?).to be(true)

      listing1.destroy

      listing1.run_callbacks(:destroy)
      expect(user.is_host?).to be(false)
    end
  end

  describe "#average_review_rating" do
    let(:reservations) do
      [Reservation.create(
        listing: listing,
        check_in: 10.days.ago,
        check_out: 5.days.ago,
        status: 'accepted'
      ), Reservation.create(
         listing: listing,
         check_in: 30.days.ago,
         check_out: 29.days.ago,
         status: 'accepted'
       )]
    end

    let!(:reviews) do
      [Review.create(
        rating: 1,
        description: 'foo',
        reservation: reservations[0]
      ), Review.create(
         rating: 3,
         description: 'bar',
         reservation: reservations[1]
       )]
    end

    it 'calculates average rating from reviews' do
      expect(listing.average_review_rating).to eq(3)
    end
  end
end
