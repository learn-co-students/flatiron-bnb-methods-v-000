module Reservable
  extend ActiveSupport::Concern

  def openings(d1, d2)
    self.listings.each do |l|
      l.reservations.each do |r|
        d1.to_date > r.checkout && d2.to_date < r.checkin
      end
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end

  class_methods do
    # use of 'class_methods' is good, but I think is something that the curriculum 
    # does not currently cover, so would need to be added.
    def highest_ratio_res_to_listings

      all.max do |a, b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end

    def most_res
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end
end