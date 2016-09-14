module Helper
  extend ActiveSupport::Concern

  def openings(checkin, checkout)
    listings = []

    self.listings.each do |listing|
      if !check_listing(listing, checkin, checkout)
        listings << listing
      end
    end

    listings
  end
  
  module ClassMethods
    def res_to_listings
      ratio = {}

      self.all.each do |area|
        area_listings = area.listings.length
        res = 0

        area.listings.each do |listing|
          res += listing.reservations.count do |reservation|
            reservation
          end
        end
        area_ratio = res * 1.0 / area_listings
        ratio[area.id] = area_ratio
      end

      test_value = 0
      area_return_value = nil
      ratio.each do |area_id, ratio|
        if ratio > test_value
          test_value = ratio
          area_return_value = area_id
        end
      end
      area_return_value
    end

    def area_most_res
      area_hash = {}
      self.all.each do |area|
        res = 0
        area.listings.each do |listing|
          res += listing.reservations.count do |reservation|
            reservation
          end
        end
        area_hash[area.id] = res
      end

      test_count = 0
      area_return_id = nil
      area_hash.each do |area_id, reservation_count|
        if reservation_count > test_count
          test_count = reservation_count
          area_return_id = area_id
        end
      end
      area_return_id
    end
  end

  private
  def check_listing(listing, checkin, checkout)
    checkin = Date.parse(checkin)
    checkout = Date.parse(checkout)

    listings = listing.reservations.any? do |reservation|
      reservation.checkin.between?(checkin, checkout) || reservation.checkout.between?(checkin, checkout)
    end

    listings
  end

end
