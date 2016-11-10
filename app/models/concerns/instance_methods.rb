module InstanceMethods
  extend ActiveSupport::Concern

  def parse_overlap(start_date, end_date)
    self.listings.select do |listing|
      listing.reservations.none? do |reservation|
        (Date.parse(start_date) <= reservation.checkout) && (Date.parse(end_date) >= reservation.checkin)
      end
    end
  end
end
