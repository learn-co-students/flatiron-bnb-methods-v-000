module Queriable
  extend ActiveSupport::Concern


  def openings(start_date, end_date)
    listings.select do |listing| 
      !listing.reservations.any? {|rez| (rez.checkin..rez.checkout).overlaps?(Date.parse(start_date)..Date.parse(end_date))}
    end
  end

  module ClassMethods

    def highest_ratio_res_to_listings  
      result_ratio = 0.to_f
      result = self.first

      self.all.each do |loc|
        current_ratio = loc.reservations.count.to_f / loc.listings.count.to_f
        if current_ratio > result_ratio
          result = loc
          result_ratio = current_ratio
        end
      end
      result
    end

    def most_res

      current_rez = 0
      result_loc = self.first
      self.all.each do |loc|
        if loc.reservations.count > current_rez
          result_loc = loc
          current_rez = loc.reservations.count
        end
      end

      result_loc
    end

  end


end