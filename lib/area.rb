module Area

  module ClassMethods
    
    def highest_ratio_res_to_listings
      max = -1
      ans = nil
      self.all.each do |c|
        ratio = c.reservations.length / c.listings.length.to_f
        if ratio > max
          max = ratio 
          ans = c
        end
      end
      ans
    end

    def most_res
      self.all.max_by do |c|
        c.reservations.length
      end
    end

  end

  module InstanceMethods

    def openings(d1, d2)
      ans = []
      date1 = Date.parse(d1)
      date2 = Date.parse(d2)
      self.listings.each do |l|
        l.reservations.each do |r|
          if r.checkin.between?(date1, date2) && r.checkout.between?(date1, date2)
            ans << l
            break
          end
        end
      end
    end

  end
    
end