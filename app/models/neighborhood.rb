class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    # binding.pry
    # self.listings
  end

  def self.highest_ratio_res_to_listings
    city_ratio_array = Neighborhood.all.map do |city| 
      listings_count = city.listings.count
      reservations_count =  city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash = {}
      hash[:reservation_ratio] = reservations_count.to_f / listings_count.to_f
      hash[:city] = city
      hash
    end
    city_ratio_array.select! {|f| f[:reservation_ratio] >= 0}
    city_ratio_array.max_by{|f| f[:reservation_ratio]}[:city]
  end

  def self.most_res
    city_reservations_array = Neighborhood.all.map do |city|
      hash = {}
      hash[:reservations_count] = city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash[:city] = city 
      hash
    end
    city_reservations_array.delete_if {|f| f[:reservations_count].nil?}
    city_reservations_array.max_by{|f| f[:reservations_count]}[:city]
  end
end
