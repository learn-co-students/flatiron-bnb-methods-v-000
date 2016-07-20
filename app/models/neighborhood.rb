class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

    def neighborhood_openings(d1, d2)
      listings.joins(:reservations).where.not(:reservations => {checkin: d1..d2, checkout: d1..d2})
    end

    def find_ratio
      neighborhood_listings = Listing.all.find_all {|l| l.neighborhood_id = self.id}

      if neighborhood_listings.count > 0
        self.reservations.count.to_f / neighborhood_listings.count.to_f
      end
    end

    def self.highest_ratio_res_to_listings
        all.max do |a, b|
          a.find_ratio <=> b.find_ratio
        end
    end
    
      def self.most_res
        Neighborhood.all.max do |a, b|
          a.reservations.count <=> b.reservations.count
        end
      end

end
