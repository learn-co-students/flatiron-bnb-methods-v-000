module AreaStats
  def highest_ratio_res_to_listings
    highest_ratio = 0
    highest_ratio_area = self.first
    self.all.each do |area|
      ratio = area.reservations.count.to_f/area.listings.count.to_f
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_ratio_area = area
      end
    end
    highest_ratio_area
  end

  def most_res
    most_res = 0
    most_res_area = self.first
    self.all.each do |area|
      area.reservations.count
      if area.reservations.count > most_res
        most_res = area.reservations.count
        most_res_area = area
      end
    end
    most_res_area
  end

end