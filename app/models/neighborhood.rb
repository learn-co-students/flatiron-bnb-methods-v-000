require 'pry'

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(date1, date2)
    self.listings.find_all{|listing| listing.available?(date1, date2)}
  end

  def self.highest_ratio_res_to_listings
    n_with_listing = []
      Neighborhood.all.each do |n|
        n_with_listing << n if n.listings.count > 0 
      end

    n_with_listing.max_by{|n| n.total_reservations / n.listings.count }
  end

  def self.most_res
    Neighborhood.all.max_by{|n| n.total_reservations}
  end

  def total_reservations  
    self.listings.inject(0) {|sum, listing| sum + listing.reservations.count}
  end


end
