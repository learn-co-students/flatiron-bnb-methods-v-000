class Neighborhood < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :city
  has_many :listings, inverse_of: :neighborhood
  has_many :reservations, through: :listings



    def neighborhood_openings(s_date, e_date)
      input = Date.parse(e_date)..Date.parse(s_date)

      Helpers.openings(self.listings, input)
    end

    def self.highest_ratio_res_to_listings
      city_with_most = ""
      index = 0
      all.each do |city|
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
       city_with_most = ""
       index = 0
       all.each do |city|
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


end
