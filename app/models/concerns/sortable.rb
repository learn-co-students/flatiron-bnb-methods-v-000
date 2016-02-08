module Sortable 

  def highest_ratio_res_to_listings
    hash = {}
    self.all.each do |item|
      hash[item.name] = (item.reservations.size / item.listings.size rescue 0)
    end
    highest = hash.max_by{|key, value| value }[0]
    self.find_by_name(highest)
  end 

  def most_res
    hash = {}
    self.all.each do |item|
      hash[item.name] = (item.reservations.size)
    end
    highest = hash.max_by{|key, value| value }[0]
    self.find_by_name(highest)
  end 

end  