class Neighborhood < ActiveRecord::Base
  belongs_to :city, counter_cache: true
  has_many :listings
  has_many :reservations, through: :listings



   def neighborhood_openings(start_date, end_date)
    @listings = Listing.all
   end

   def res_ratio
   neighborhood_listings = Listing.all.find_all{|l| l.neighborhood_id = self.id}
   self.reservations.count / neighborhood_listings.count
  end

  def self.highest_ratio_res_to_listings
     
     Neighborhood.all.max_by {|neighborhood| neighborhood.res_ratio}
  end

  def highest_res
    reservations.count
  end

  def self.most_res
  Neighborhood.all.max_by {|city| city.highest_res}
  end
end
