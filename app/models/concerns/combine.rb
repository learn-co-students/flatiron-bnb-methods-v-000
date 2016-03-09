module Combine

  def highest_ratio_res_to_listings
    reserved = {}
    total = 0
    self.all.each do |city|
      new_place = city.reservations.count
      if new_place > total
        total = new_place
        reserved = city
      end
    end
    reserved
  end

  def most_res
    reserved = {}
    total = 0
    self.all.each do |city|
      new_place = city.reservations.count
      if new_place > total
        total = new_place
        reserved = city
      end
    end
    reserved
  end

end