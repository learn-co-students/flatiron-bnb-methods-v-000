class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


    def city_openings(first_day, last_day)
      listings.each do |list|
        list.reservations.collect do |reservation|
          reservation.checkin == first_day && reservation.checkout == last_day
        end
      end
    end

    def self.highest_ratio_res_to_listings
      @cities=[]
      all.each do |city|
        @cities << city if city.listings.count > 0
      end
      @cities.max_by do |city|
        city.reservations.count / city.listings.count
      end
    end

    def self.most_res
      all.max_by do |city|
        city.reservations.count
      end
    end

end
