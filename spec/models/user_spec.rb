describe User do
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
  let!(:reservation) do
    Reservation.create(
      check_in: '2014-04-25',
      check_out: '2014-04-30',
      guest: guest,
      listing: listing,
      status: 'accepted'
    )
  end
  let!(:review) do
    Review.create(
      description: 'awful',
      guest: guest,
      rating: 0,
      reservation: reservation
    )
  end

  it '#name' do
    expect(guest.name).to eq('Guest')
  end


  context 'as host' do
    it '#is_host?' do
      expect(host.is_host?).to be(true)
    end

    it 'has_many listings' do
      expect(host.listings).to include(listing)
    end

    it 'has_many reservations through listings' do
      expect(host.reservations).to include(reservation)
    end

    it 'has had many guests' do
      expect(host.guests).to include(guest)
    end

    it 'has received many reviews' do
      expect(host.host_reviews).to include(review)
    end
  end

  context 'as guest' do
    it 'has_many trips' do
      expect(guest.trips)  
    end

    it 'has had many hosts' do
      expect(guest.hosts).to include(host)
    end

    it 'has written many reviews' do
      expect(guest.reviews).to include(review)
    end
  end
end
