
class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    date_time_start = DateTime.strptime(start_date, "%Y-%m-%d")
    date_time_end = DateTime.strptime(end_date, "%Y-%m-%d")

    all_listings = []

    self.listings.each do |listing|
      if listing.reservations.each do |reservation|
          reservation.checkin <= date_time_end && reservation.checkout >= date_time_start
        end
        all_listings << listing
      else
      end

    end

    all_listings

  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by do |nabe|
      nabe.res_ratio.to_f
    end
  end

  def res_ratio
      res_count = 0

      if self.listings.any?
        self.listings.each do |listing|
          res_count = res_count + listing.reservations.count
        end
        res_count.to_f / self.listings.count
      else
      end
  end

  def self.most_res
    Neighborhood.all.max_by do |city|
      city.all_res_by_listing.sum
    end
  end

  def all_res_by_listing
    self.listings.collect do |listing|
      listing.reservations.count
    end
  end

end
