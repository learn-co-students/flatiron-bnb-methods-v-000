class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
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

  def neighborhood_openings(start_date, end_date)
    openings(start_date, end_date)
  end

  def res_count
    if listings.count > 0
      res_count = 0
      listings.each do |listing|
        res_count += listing.reservations.count
      end
      res_count
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      res_count.to_f / listings.count.to_f
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
    end
  end

  def self.most_res
    all.max do |a, b|
      a.res_count <=> b.res_count
    end
  end

end
