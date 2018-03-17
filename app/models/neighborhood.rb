class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

   def neighborhood_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.each do |res|
        start_date <= res.checkout.to_s && end_date >= res.checkin.to_s
      end
    end
  end


   def self.highest_ratio_res_to_listings
    neighborhood_id = 0
    max_ratio = 0

    self.all.each do |neighborhood|
      listings_count = neighborhood.listings.count
      reservations_count = neighborhood.listings.collect{|listing| listing.reservations.count}.inject(0) { |sum, n| sum + n }
      if listings_count > 0
        ratio = reservations_count / listings_count
      else
        ratio = 0
      end
      if ratio > max_ratio
        max_ratio = ratio
        neighborhood_id = neighborhood.id
      end
    end
    self.find(neighborhood_id)
  end


   def self.most_res
    neighborhood_id = 0
    max_reservations_count = 0

    self.all.each do |neighborhood|
      reservations_count = neighborhood.listings.collect{|listing| listing.reservations.count}.inject(0) { |sum, n| sum + n }
      if reservations_count > max_reservations_count
        max_reservations_count = reservations_count
        neighborhood_id = neighborhood.id
      end
    end
    self.find(neighborhood_id)
  end




end
