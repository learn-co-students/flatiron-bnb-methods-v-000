module LocationQuerys

  def num_of_reservations
    self.listings.inject(0) do |sum, listing|
      sum + listing.reservations.size
    end
  end

  def res_to_listings
      if self.listings.size > 0
        self.num_of_reservations/self.listings.size
      else
        0
      end
  end


  module ClassMethods
    def highest_ratio_res_to_listings
      all.max_by do |a|
        a.res_to_listings
      end
    end

    def most_res
      all.max_by {|a| a.num_of_reservations}
    end
  end

end
