class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(starting, ending)
    results = []
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)
    self.listings.each do |listing|
      valid = true
      listing.reservations.each do |reservation|
        if !(reservation.checkin > end_date || reservation.checkout < start_date)
          valid = false
        end
      end
      if valid
        results << listing
      end
    end
    results
  end

    def self.highest_ratio_res_to_listings
      high = 0
      return_neighborhood = nil
      Neighborhood.all.each do |neighborhood|
        listings = neighborhood.listings.count
        reservations = 0
        neighborhood.listings.all.each do |listing|
          reservations += listing.reservations.count
        end
        if listings > 0
          ratio = reservations / listings
          if ratio > high
            return_neighborhood = neighborhood
            high = ratio
          end
        end
      end
      return_neighborhood
    end

    def self.most_res
      high = 0
      return_neighborhood = nil
      Neighborhood.all.each do |neighborhood|
        reservations = 0
        neighborhood.listings.all.each do |listing|
          reservations += listing.reservations.count
        end
        if reservations > high
          return_neighborhood = neighborhood
          high = reservations
        end
      end
      return_neighborhood
    end


end
