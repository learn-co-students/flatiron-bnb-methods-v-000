module Stats

  module InstanceMethods

    def openings(start_date, end_date)
      self.listings.select {|listing| !listing.reservations.any? {|reservation| (reservation.checkin..reservation.checkout).overlaps?(start_date.to_date..end_date.to_date) && reservation.status == "accepted"}}
    end

  end

  module ClassMethods

    def highest_ratio_res_to_listings
      ratios = Hash.new(0)
      all.map{|division| division.id}.each do |id|
        res = find(id).listings.map{|listing| listing.reservations.count}.sum
        listings = find(id).listings.count
        if listings != 0
          ratios[id] = res/listings
        end
      end
      find(ratios.max_by{|id,ratio| ratio}[0])
    end

    def most_res
      counts = Hash.new(0)
      all.map{|division| division.id}.each do |id|
        counts[id] = find(id).listings.collect{|listing| listing.reservations.count}.sum
      end
      find(counts.max_by{|id,count| count}[0])
    end

  end

end
