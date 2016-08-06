module Res

  def most_res
    @winner = {}
    self.all.each do |area|
      area.listings.each do |list|
        count = list.reservations.count
        if @winner["count"].nil? 
          @winner["area"] = area
          @winner["count"] = count
        elsif @winner["area"] == area
          @winner["count"] += count  
        elsif count > @winner["count"] 
          @winner["area"] = area
          @winner["count"] = count
        end
      end
    end
    @target = @winner["area"]
  end


  def highest_ratio_res_to_listings
    @winner = {}
    self.all.each do |area|
      list_count = area.listings.count
      area.listings.each do |list|
        res_count = list.reservations.count
        if list_count != 0
         ratio = (res_count / list_count.to_f)
        end
        if @winner["ratio"].nil? 
          @winner["area"] = area
          @winner["ratio"] = ratio  
        elsif ratio > @winner["ratio"] 
          @winner["area"] = area
          @winner["ratio"] = ratio
        end
      end
    end
    @target = @winner["area"]
  end
end