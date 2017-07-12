class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings



  def city_openings(s_date, e_date)

    input = Date.parse(e_date)..Date.parse(s_date)
    Helpers.openings(self.listings, input)

  end


  def self.highest_ratio_res_to_listings
    city_with_most = ""
    index = 0
    City.all.each do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      if reservation_count > index
       index = reservation_count
       city_with_most = city
     end
    end
    city_with_most
   end

   def self.most_res
     index = 0
     city_with_most_res = ""
      self.all.each do |city|
        if city.reservations.count > index
          index = city.reservations.count
          city_with_most_res = city
        end
      end
      city_with_most_res
   end





end
