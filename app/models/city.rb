class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  def city_openings(date1, date2)
    listings(Listing.available(date1, date2))
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

def self.highest_ratio_res_to_listings 
  # return the City that is "most full"
  # aka highest amount of reservations per listing
  # city reservation : listings
 all.max do |a, b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
end

def self.most_res 
  all.max do |a, b|
    a.reservations.count <=> b.reservations.count
  end
end



  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  # class_methods do
  #   # use of 'class_methods' is good, but I think is something that the curriculum 
  #   # does not currently cover, so would need to be added.
  #   def highest_ratio_reservations_to_listings

  #     all.max do |a, b|
  #       a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
  #     end
  #   end

  #   def most_reservations
  #     all.max do |a, b|
  #       a.reservations.count <=> b.reservations.count
  #     end
  #   end
  # end
  
end

