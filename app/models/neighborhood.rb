class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date_start, date_end)
    self.listings.select do |listing|
      !listing.reservations.any? do |reservation|
        (Date.parse(date_start.to_s) - Date.parse(reservation.checkout.to_s)) * (Date.parse(reservation.checkin.to_s) - Date.parse(date_end.to_s)) >= 0
      end
    end
  end

  def self.highest_ratio_res_to_listings
    sorted_neighborhoods = Neighborhood.all.sort do |x,y|
      res_to_listings_ratio(y) <=> res_to_listings_ratio(x)
    end
    sorted_neighborhoods.first
  end

  def self.res_to_listings_ratio(neighborhood)
    if neighborhood.listings.empty?
      0
    else
      number_res(neighborhood) / neighborhood.listings.size
    end
  end

  def self.most_res
    sorted_neighborhoods = Neighborhood.all.sort do |x,y|
      number_res(y) <=> number_res(x)
    end
    sorted_neighborhoods.first
  end

  def self.number_res(neighborhood)
    number_of_reservations = 0
    neighborhood.listings.each do |listing|
      number_of_reservations += listing.reservations.size
    end
    number_of_reservations
  end

end
