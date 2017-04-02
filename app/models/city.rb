class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
      self.listings.find_all do |listing|
      listing.reservations.all? do |res|
         (checkin.to_datetime >= res.checkout) || (checkout.to_datetime <= res.checkin)
      end
    end
  end

  def self.highest_ratio_reservations_to_listings
    highest_ratio_city = nil
    city_ratio = 0
    i=0

    City.all.each do |city|
      city_total = city.listings.collect do |listing|
        listing.reservations.count
        i+=1
      end.inject(0) {|sum, x| sum + x}

      if city_total/i > city_ratio
        highest_ratio_city = city
        city_ratio = city_total/i
      end
    end

    return highest_ratio_city
  end

  def self.most_reservations
    fullest_city = nil
    total_city_res = 0

    City.all.each do |city|
      city_total = city.listings.collect do |listing|
        listing.reservations.count
      end.inject(0) {|sum, x| sum + x}

      if city_total > total_city_res
        fullest_city = city
        total_city_res = city_total
      end
    end

    return fullest_city
  end
end

## Passes solution branch.  Fails master branch specs for instance, class methods; failures traced back to Reservation model validation #is_available (validation passes both branches' specs)
