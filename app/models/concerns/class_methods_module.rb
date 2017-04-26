module ClassMethods
  def self.highest_ratio_res_to_listings
    sorted  = self.all.sort_by { |city| city.reservations.count.to_f / city.listings.count.to_f}.reverse
    highestratio = sorted.first
  end

  def self.most_res
    sorted = self.all.sort_by { |city| city.reservations.count }.reverse
    mostres = sorted.first
  end
end
