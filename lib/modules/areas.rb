module Areas
  module InstanceAreas

    def openings(checkin_date, checkout_date)

        openings = listings.reject do |l|
          l.reservations.any? do |r|
            dates = (checkin_date..checkout_date)
            dates.include?(r.checkin) || dates.include?(r.checkout)
          end
        end

      openings
    end
  end

  module ClassAreas
    def most_res
      sorted_areas = all.sort_by do |area|
        total_reservations(area)
      end.reverse

      sorted_areas.first
    end

    def highest_ratio_res_to_listings
      sorted_areas = all.sort_by do |area|
        # binding.pry
        unless area.listings.none?
          area_reservations = total_reservations(area).to_f
          area_listings = area.listings.count
          area_reservations / area_listings
        else
          0
        end
      end.reverse

      sorted_areas.first
    end


  protected
    def total_reservations(area)
      area.listings.inject(0) do |sum, l|
        sum += l.reservations.count
      end
    end
  end
end
