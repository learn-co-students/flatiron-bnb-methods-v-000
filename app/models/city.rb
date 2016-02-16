class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  #passes returning all listings belonging to city
  def city_openings(start_date, end_date)
    # binding.pry
    #this will have to look into reservations i think
    #look at each listing
    #for each listing look at all reservations
    #check if check in or checkout falls between start and end date
    # greater than or equal to checkin

    # probably should really be the responsibility of the 
    #reservation to do it.  


    # start_date_arr = start_date.split("-")
    # end_date_arr = end_date.split("-")
    # start_date_time = Time.new(start_date_arr[0], start_date_arr[1], start_date_arr[2])
    # end_date_time = Time.new(end_date_arr[0], end_date_arr[1], end_date_arr[2])

    # self.listings.map do |listing|
    #   reservation_conflict = false
    #   listing.reservations.each do |reservation|
    #     if start_date >= reservation.checkout
    #       # reservation_conflict = false
    #     elsif
    #       if end_date <= reservation.checkin
    #         # reservation_conflict = false
    #       end
    #     else
    #       reservation_conflict = true
    #     end
    #   end
    #   reservation_conflict
    # end
    # binding.pry
    # self.listings

  end

  def self.highest_ratio_res_to_listings
    city_ratio_array = City.all.map do |city| 
      listings_count = city.listings.count
      reservations_count =  city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash = {}
      hash[:reservation_ratio] = reservations_count.to_f / listings_count.to_f
      hash[:city] = city
      hash
    end
    city_ratio_array.max_by{|f| f[:reservation_ratio]}[:city]
  end

  def self.most_res
    city_reservations_array = City.all.map do |city|
      hash = {}
      hash[:reservations_count] = city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash[:city] = city 
      hash
    end
    city_reservations_array.max_by{|f| f[:reservations_count]}[:city]
  end
end

