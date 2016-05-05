class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

#unsure why this works
  def city_openings(start_date, end_date)
    listings.where(start_date, end_date)
    #also listings.merge(Listing.where((start_date, end_date))
  end


#refactor
  def self.highest_ratio_res_to_listings
    best_ratio = {}
    City.all.each do |city|
      list_count = 0
      res_count = 0
      list_count += city.listings.count
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      ratio = res_count / list_count
      best_ratio[city] = ratio
    end
    best_ratio.max_by {|key, value| value}[0]
  end

#refactor
  def self.most_res
    most_res = {}
    City.all.each do |city|
      res_count = 0
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      most_res[city] = res_count
    end
    most_res.max_by {|key, value| value}[0]
  end
end
