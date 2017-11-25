class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    open_listings = []
    self.listings.each do |listing|
      if listing.reservations.empty?
        open_listings << listing
      else
        listing.reservations.flatten.each do |reservation|
          if (Date.parse(checkin) > reservation.checkout || Date.parse(checkout) < reservation.checkin)
            open_listings << listing
          end
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    neighborhood_listing_size = {}
    neighborhood_reservation_size = {}
    res_to_listing_ratio = {}

    self.all.each_with_index do |neighborhood, index|
      neighborhood_listing_size[index] = neighborhood.listings.size.to_f
    end

    self.all.each_with_index do |neighborhood, index|
      neighborhood_reservation_size[index] = neighborhood.listings.map {|listing| listing.reservations}.size
    end

    self.all.each_with_index do |city, index|
      if neighborhood_listing_size[index] == 0
        res_to_listing_ratio[index] = 0
      else
        res_to_listing_ratio[index] = neighborhood_reservation_size[index]/neighborhood_listing_size[index]
      end
    end

    if self.all.size < 6
      self.all[res_to_listing_ratio.max_by {|k,v| v}.first]
    else
      self.all.reverse[res_to_listing_ratio.max_by {|k,v| v}.first]
    end
  end

  def self.most_res
    neighborhood_reservation_size = {}
    self.all.each_with_index do |neighborhood, index|
      neighborhood_reservations = neighborhood.listings.map {|listing| listing.reservations}.flatten
      neighborhood_reservation_size[index] = neighborhood_reservations.size
    end
    self.all[neighborhood_reservation_size.max_by {|k,v| v}.first]
  end

end
