class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(date_1, date_2)
    Listing.all
  end

  def self.highest_ratio_res_to_listings
    # Reservation.all <=> Listing.all
    # find the city with the highest ratio of reservations to listings
    # city_names = City.all.group(:name)
    # listing_names = Listing.all.group(:name)
    # City.find_by
      hash ={}
      City.all.map do |city|
        hash["#{city.name}"] = city.reservations
        hash
      end

      highest = nil
      hash.max_by do |key, array|
         hash[key][-1]
      end
      # c_l = Reservation.all.map { |c| c.listing  }
      # l_r = Listing.all.each { |l| l.reservations }
      # c_l_count / l_r_count
    # c = City.find_by(:name).maximum(:listings)
    # expect(City.highest_ratio_res_to_listings).to eq(City.find_by(:name => "Denver"))
    # find city with the highest reservations
    # count the reservations for each city
    # store each city's reservation in array called ccity reservation
    # then count each array and whichever array has the highest count it's city's name will be the answer.
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
