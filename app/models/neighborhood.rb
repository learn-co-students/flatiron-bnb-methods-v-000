class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start, enddate)
    range = (start.to_date)..(enddate.to_date)
      listing_list = []
      self.listings.collect do |listing|
        has_openings = !listing.reservations.any? do |reservation|
          res_range = reservation.checkin..reservation.checkout
          range === res_range
        end
        if has_openings
          listing
        end
      end
    end

    def self.highest_ratio_res_to_listings
      # binding.pry
      neighborhood_ratios = {}
      ratios = self.all.collect do |n|
        listing_count     = n.listings.count
        reservations = []
        n.listings.each do |l|
          l.reservations.each do |r|
            reservations << r
          end
        end
        neighborhood_ratios[(reservations.count / listing_count.to_f)] = n
        (reservations.count / listing_count.to_f)
      end.reject! &:nan?
      ratio = ratios.max
      neighborhood_ratios[ratio]
    end
    def self.most_res
      neighborhood_reservations = {}
      most_reservations = self.all.collect do |c|
        reservations = []
        c.listings.each do |l|
          l.reservations.each do |r|
            reservations << r
          end
        end
        neighborhood_reservations[c] = reservations.count
        reservations.count
      end.max
      neighborhood_reservations.select{|neighborhood, res_count| res_count == most_reservations}.keys[0]
    end

end
