describe Review do
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
  let(:review) do
    Review.create(
      description: 'baller',
      guest: guest,
      rating: 5,
      reservation: reservation
    )
  end

  it 'has a description' do
    expect(review.description).to eq("baller")
  end

  it 'has a rating' do
    expect(review.rating).to eq(5)
  end

  it 'belongs to a guest' do
    expect(review.guest).to eq(guest)
  end

  it 'belongs to a reservation' do
    expect(review.reservation).to eq(reservation)
  end

  it 'is valid with a rating and description' do
    expect(review).to be_valid
  end

  it 'is invalid without a rating' do
    expect(Review.new(description: 'foo', guest: guest, reservation: reservation)).not_to be_valid
  end

  it 'is invalid without a description' do
    expect(Review.new(guest: guest, rating: 4, reservation: reservation)).not_to be_valid
  end

  it 'is invalid without a reservation' do
    expect(Review.new(description: 'foo', guest: guest, rating: 2)).not_to be_valid
  end

  it 'is invalid unless reservation is accepted' do
    r = Reservation.create(
      check_in: '2014-04-25',
      check_out: '2014-04-30',
      guest: guest,
      listing: listing
    )

    expect(
      Review.new(
      description: 'foo',
      guest: guest,
      rating: 4,
      reservation: r
    )).not_to be_valid
  end

  it 'is invalid unless its reservation has ended' do
    r = Reservation.create(
      check_in: Date.today - 1.day,
      check_out: Date.today + 1.day,
      guest: guest,
      listing: listing,
      status: 'accepted'
    )

    expect(
      Review.new(
      description: 'foo',
      guest: guest,
      rating: 4,
      reservation: r
    )).not_to be_valid
  end
end
