
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


    def city_openings(checkin_date, checkout_date)

      City.all.each do |each_city|
          each_city.listings.each do |each_listing|
            each_listing.reservations.map do |each_reservation|
              if each_reservation.checkin == checkin_date
                       binding.pry
             end
      # select(checkincheckin .. checkout)
          end
        end
      end
    end

end
