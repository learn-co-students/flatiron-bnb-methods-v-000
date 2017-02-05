module Location
  def highest_ratio_res_to_listings
    max_city_ratio = 0
    highest_ratio = nil
    all.each do |city|
      rez_count = 0
      city.listings.each do |listing|
        rez_count += listing.reservations.count
      end
      if rez_count > 0
        city_ratio = rez_count / city.listings.count
      else
        city_ratio = 0
      end
      if city_ratio > max_city_ratio
        max_city_ratio = city_ratio
        highest_ratio = city
      end
    end
    highest_ratio
  end

  def most_res
    max_rez_count = 0
    most_rez = nil
    all.each do |city|
      rez_count = 0
      city.listings.each do |listing|
        rez_count += listing.reservations.count
      end

      if rez_count > max_rez_count
        max_rez_count = rez_count
        most_rez = city
      end
    end
    most_rez
  end
end

class City < ActiveRecord::Base
  extend Location
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    st_dt = Date.parse(start_date)
    ed_dt = Date.parse(end_date)
    openings = []
    conflict_rez = []
    self.listings.each do |listing|
      listing.reservations.each do |rez|
        if rez.checkin <= ed_dt && rez.checkout >= st_dt
          conflict_rez << rez
        end
      end
      if conflict_rez.empty?
        openings << listing
      end
      conflict_rez.clear
    end
    openings
  end

end
