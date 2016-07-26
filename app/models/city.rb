class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

def city_openings(start_date, end_date)
    self.listings.map do |listing|
      if listing.reservations.empty?
        [listing]
      else
        listing.reservations.map do |reservation|
          if (Date.strptime(end_date, '%Y-%m-%d') <= reservation.checkin || Date.strptime(start_date, '%Y-%m-%d') >= reservation.checkout)
            Listing.find_by(id: reservation.listing_id)
          end
        end
      end
    end.delete_if { |listing| listing.include?(nil) }.flatten.uniq
  end

  def self.highest_ratio_res_to_listings
    res_count = 0
    high = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if res_count < listing.reservations.count
          res_count = listing.reservations.count
          high = city
        end
      end
    end
    high
  end

  def self.most_res
    city_res_count = 0
    most_res = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          most_res = city
        end
      end
    end
    most_res
  end

end

