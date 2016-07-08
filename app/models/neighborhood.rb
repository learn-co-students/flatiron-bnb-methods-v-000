class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
     listings.merge(Listing.available(date1, date2))
  end


  def ratio_reservations_to_listings
    if listings.count > 0 
        reservations.count.to_i / listings.count.to_i
   end
    end

# class methods
  def self.highest_ratio_res_to_listings
    all.max do |a, b|
     a.ratio_reservations_to_listings.to_i <=> b.ratio_reservations_to_listings.to_i
    end
  end

  def self.most_res
    all.max do |a, b|
      a.reservations.count.to_i / b.reservations.count.to_i
    end
  end

end
