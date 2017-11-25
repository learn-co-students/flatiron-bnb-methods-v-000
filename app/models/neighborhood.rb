class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


      def neighborhood_openings(first_day, last_day)
        listings.each do |list|
          list.reservations.collect do |reservation|
            reservation.checkin == first_day && reservation.checkout == last_day
          end
        end
      end

      def self.highest_ratio_res_to_listings
        @neighborhoods = []
        all.each do |neighborhood|
          @neighborhoods << neighborhood if neighborhood.listings.count > 0
        end
        @neighborhoods.max_by do |neighborhood|
          neighborhood.reservations.count / neighborhood.listings.count
        end
      end

      def self.most_res
        all.max_by do |neighborhood|
          neighborhood.reservations.count
        end
      end

end
