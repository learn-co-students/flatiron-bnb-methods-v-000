module FindAvailableListings
  module InstanceMethods

    def neighborhood_openings(date1, date2)
      Listing.all.each do |listing|
        listing_reservations(listing, date1, date2)
      end
    end

    def listing_reservations(listing, date1, date2)
      openings = []
      listing.reservations.each do |reservation|
        if !(date1 <= checkout(reservation)) and (date2 <= checkin(reservation))
          openings << listing
        end
      end
    end

    def checkin(reservation)
      reservation.checkin.strftime
    end

    def checkout(reservation)
      reservation.checkout.strftime
    end

  end

  module ClassMethods
    def cities
      City.all
    end

    def highest_ratio_res_to_listings
      max_self(self_ratios)
    end

    def max_self(hash)
      max = hash.values.max
      map = hash.select { |k, v| v == max}
      self.find_by(name: map.keys)
    end

    def self_ratios
      self_ratios = {}
      reservations_by_self.each do |x, count|
        if listings_by_self(x).count != 0
          self_ratios[x] = count/listings_by_self(x).count.to_f
        end
      end
      self_ratios
    end

    def listings_by_self(instance)
      instance_listings = {}
      self.all.each do |x|

        instance_listings[x.name] = x.listings
      end
      instance_listings[instance]
    end

    def reservations_by_self
      self_reservations = {}
      self.all.each do |x|
        self_reservations[x.name] = self_name_of_reservation(x).count
      end
      self_reservations
    end

    def self_name_of_reservation(x)
      reservation_by_self = []
      Reservation.all.each do |r|
        if r.listing.neighborhood.name == x.name
          reservation_by_self << r
        end
      end
      reservation_by_self
    end

    def most_res
      max_self(reservations_by_self)
    end
  end

end
