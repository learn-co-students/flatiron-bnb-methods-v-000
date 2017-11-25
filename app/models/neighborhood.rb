class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    array = []
    self.listings.each do |x|
      if x.available?(checkin, checkout)
        array << x
      end
    end
    array.flatten
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = -100
    highest_hood = nil
    self.all.each do |hood|
      list_count = hood.listings.count
      res_count = 0
      hood.listings.each do |list|
        res_count += list.reservations.count
      end
      ratio = res_count.to_f / list_count
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_hood = hood
      end
    end
    highest_hood
  end

  def self.most_res
    highest_hood = nil
    res_count = 0
    self.all.each do |hood|
      new_res_count = 0
      hood.listings.each do |list|
        new_res_count += list.reservations.count
      end
      if new_res_count > res_count
        res_count = new_res_count
        highest_hood = hood
      end
    end
    highest_hood
  end

end
