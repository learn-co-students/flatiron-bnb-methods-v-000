class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    #(date1 <= date2)
    Listing.all
  end

  def highest_ratio_res_to_listings

  end

  def most_res

  end
  
end

