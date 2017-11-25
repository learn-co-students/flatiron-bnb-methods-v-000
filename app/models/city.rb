class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    openings = []
    self.listings.each do |x|
      if x.available?(checkin, checkout)
        openings << x
      end
    end
    openings.flatten
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = -100
    highest_city = nil
    self.all.each do |ciudad|
      list_count = ciudad.listings.count
      res_count = 0
      ciudad.listings.each do |list|
        res_count += list.reservations.count
      end
      ratio = res_count.to_f / list_count
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_city = ciudad
      end
    end
    highest_city
  end

  def self.most_res
    highest_city = nil
    res_count = 0
    self.all.each do |ciudad|
      new_res_count = 0
      ciudad.listings.each do |list|
        new_res_count += list.reservations.count
      end
      if new_res_count > res_count
        res_count = new_res_count
        highest_city = ciudad
      end
    end
    highest_city
  end

end

