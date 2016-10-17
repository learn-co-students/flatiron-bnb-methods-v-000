class Neighborhood < ActiveRecord::Base
  include Reservable

  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    range = start_date..end_date
    self.listings.each do |listing|
      listing.reservations.collect do |reservation|
        if range === reservation.checkin.to_s < start_date || range === reservation.checkout.to_s
          next
        end
      end
    end
  end

end
