class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_1, date_2)
    Listing.all
  end

  def self.highest_ratio_res_to_listings
    # Reservation.all <=> Listing.all
    # find the city with the highest ratio of reservations to listings
    # city_names = City.all.group(:name)
    # listing_names = Listing.all.group(:name)
      c_l_count = City.all.each { |c| c.listings  }
      l_r_count = Listing.all.each { |l| l.reservations }
      c_l_count / l_r_count
    # c = City.find_by(:name).maximum(:listings)

  end

  private
    # def greater_than
    #   r = 0
    #   self.listing.all.each do |l|
    #     if l.reservations > l
    #        r +=1
    #      end
    #      r
    #   end
    #
    # end


end
