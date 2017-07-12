module Localeable
  module InstanceMethods
    def locale_openings(start_date, end_date)
      # iterate through listings in locale
      # collect them if they dont have a conflict
      checkin = Time.parse(start_date)
      checkout = Time.parse(end_date)
      listings.collect do |listing|
        if !listing.has_conflict?(checkin, checkout)
          listing
        end
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      ratio_hash = { locale: "", ratio: 0 }
      self.all.each do |locale|
        listings = locale.listings.size
        reservations = locale.listings.collect do |listing|
          listing.reservations.size
        end
        reservations = reservations.sum
        listings != 0 ? ratio = reservations / listings : ratio = 0
        if ratio_hash[:ratio] < ratio
          ratio_hash = { locale: locale, ratio: ratio }
        end
      end
      ratio_hash[:locale]
    end

    def most_res
      reservations_hash = { locale: "", reservations: 0 }
      self.all.each do |locale|
        reservations = locale.listings.collect do |listing|
          listing.reservations.size
        end
        total_reservations = reservations.sum
        if reservations_hash[:reservations] < total_reservations
          reservations_hash = { locale: locale, reservations: total_reservations }
        end
      end
      reservations_hash[:locale]
    end
  end
end
