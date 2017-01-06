class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    Listing.all.each do |list|
      list.reservations.where('checkin < ? AND checkout > ?', start, finish)
    end
  end

  def self.highest_ratio_res_to_listings
  end

  def self.most_res
  end

end
