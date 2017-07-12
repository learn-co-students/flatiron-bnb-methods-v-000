module InstanceMethods
  extend ActiveSupport::Concern

  def parse_overlap(start, finish)
    self.listings.select do |listing|
      listing.reservations.none? do |reservation|
        (Date.parse(start) <= reservation.checkout) && (Date.parse(finish) >= reservation.checkin)
      end
    end
  end
end
