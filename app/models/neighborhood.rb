class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    listings.includes(:reservations).select do |listing|
      listing.reservations.none? do |reservation|
        reservation.checkin <= end_date && start_date <= reservation.checkout
      end
    end
  end

  def self.highest_ratio_res_to_listings
    neighborhoods = Neighborhood.includes(listings: [:reservations]).all

    neighborhoods.collect do |neighborhood|
      total_listings = neighborhood.listings.count
      total_reservations = neighborhood.listings.reduce(0) do |memo, listing|
        memo += listing.reservations.count
      end

      if total_listings == 0
        ratio = 0
      else
        ratio = total_reservations / total_listings.to_f
      end

      {
        neighborhood: neighborhood,
        ratio: ratio
      }

    end.max_by { |x| x[:ratio] }[:neighborhood]
  end

  def self.most_res
    neighborhoods = Neighborhood.includes(listings: [:reservations]).all

    neighborhoods.collect do |neighborhood|
      total_res = neighborhood.listings.reduce(0) do |memo, listing|
        memo += listing.reservations.count
      end

      {neighborhood: neighborhood, total_res: total_res}
    end.max_by { |x| x[:total_res] }[:neighborhood]
  end
end

