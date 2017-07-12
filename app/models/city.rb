class City < ActiveRecord::Base
  include Reservable
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # def city_openings(start_date, end_date)
  #   range = start_date..end_date
  #   self.listings.each do |listing|
  #     listing.reservations.collect do |reservation|
  #       if range === reservation.checkin.to_s < start_date || range === reservation.checkout.to_s
  #         next
  #       end
  #     end
  #   end
  # end

end
