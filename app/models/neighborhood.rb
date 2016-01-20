require 'pry'

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    first_date = Date.parse(start_date)
    last_date = Date.parse(end_date)

    openings = []

    listings.each do |listing|
        booked = listing.reservations.any? do |r|
          first_date.between?(r.checkin, r.checkout) ||
          last_date.between?(r.checkin, r.checkout)
        end
        unless booked
          openings << listing
        end
      end
    openings
  end

  def self.highest_ratio_res_to_listings
    ratio = {}

    self.all.each do |neighborhood|
      if neighborhood.listings.count > 0
        counter = 0
        neighborhood.listings.each do |a|
          counter += a.reservations.count
        end
        ratio[neighborhood] = counter / neighborhood.listings.count
      end
    end
    ratio.key(ratio.values.sort.last)
  end

  def self.most_res
    most_res = {}

    self.all.each do |neighborhood|
      counter = 0

      neighborhood.listings.each do |a|
        counter += a.reservations.count
      end
      most_res[neighborhood] = counter
    end
    most_res.key(most_res.values.sort.last)
  end
end
