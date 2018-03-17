class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


    def neighborhood_openings(start_date, end_date)
         start_date = Date.parse(start_date)
         end_date = Date.parse(end_date)

         listings.select do |list|
           list if list.reservations.all? { |res| res.checkout <= start_date || res.checkin >= end_date }
         end
    end

    def self.highest_ratio_res_to_listings
      count = 0
      highest_ratio = ''
      self.all.each do |city|
        city.listings.each do |listing|
          if count < listing.reservations.count
            count = listing.reservations.count
            highest_ratio = city
          end
        end
      end
      highest_ratio
    end

    def self.most_res
      all.each.sort { |a,b| a.reservations.count <=> b.reservations.count  }.last
    end

end
