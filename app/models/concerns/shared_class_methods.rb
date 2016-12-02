module SharedClassMethods
  def highest_ratio_res_to_listings
    highest_ratio = self.all.map do |city|
       city.find_ratio_res_to_listings
    end.max
    self.all.select {|city| city.find_ratio_res_to_listings == highest_ratio}.first
  end



  def most_res
    most_res = self.all.map {|city| city.city_or_neighborhood_reservations}.sort.last

    self.all.select {|city| city.city_or_neighborhood_reservations == most_res}.first
  end
end