class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  # Instance method
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


  # Class methods
  def self.highest_ratio_res_to_listings
    avg_res_per_city = self.res_per_listing_per_city.map do |city_res|
      if city_res.empty?
        0
      else
        city_res.sum.to_f / city_res.count
      end
    end

    City.find_by(id: (avg_res_per_city.each_with_index.max[1] + 1))
  end

  def self.most_res
    total_res_per_city = self.res_per_listing_per_city.map do |city_res|
      if city_res.empty?
        0
      else
        city_res.sum
      end
    end

    City.find_by(id: (total_res_per_city.each_with_index.max[1] + 1))
  end




  # Helper method (and cleaning up repetitive code)
  def self.res_per_listing_per_city
    self.all.map do |city|
      city.listings.map do |listing|
        listing.reservations.count
      end
    end
  end

end
