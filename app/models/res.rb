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

  


end