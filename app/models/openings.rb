module Openings

  def openings(date1, date2)
    @all_list = Listing.all.map{|list| list}
    @all_list.each do |e|
      if e.neighborhood != self && e.city != self
        @all_list -= [e]
      end
    end

    date1 = Date.parse(date1)
    date2 = Date.parse(date2)
  
    @all_list.each do |listing|
      listing.reservations.each do |rez|
        if rez.checkin.between?(date1, date2) || rez.checkout.between?(date1, date2)
          @all_list -= [rez.listing]     
        end
      end
    end
    @all_list.each{ |item| puts item }
  end

  def self.most_res
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