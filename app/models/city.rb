class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def openings(start_date, end_date)
    open_listings = []
    Listing.all.each do |listing|
      res = Reservation.new(checkin: start_date, checkout: end_date, listing_id: listing.id)
      if res.is_available
        open_listings << listing
      end
      res.destroy
    end
    open_listings
  end

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
    end
  end

  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end

end
