class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(arrival, departure)
    dates = arrival..departure
    self.listings.select {|listing| (((listing.reservations) & dates.to_a).empty?)} 
  end

  def reservations
    self.listings.map {|i| i.reservations}
  end

   def ratio
    if listings.count > 0  
      self.reservations.count.to_f / self.listings.count.to_f
    else 
      0.0
    end
  end

  def self.highest_ratio_res_to_listings
    ratio_array = self.all.map {|i| {ratio: i.ratio, instance: i}}
    highest = ratio_array.sort_by{|hash| hash[:ratio] }.shift
    highest[:instance]
  end

  def self.most_res
    reserv = self.all.map {|i| {reservations: i.reservations.count, instance: i}}
    most = reserv.sort_by{|hash| hash[:reservations]}.pop
    most[:instance]
  end



end

