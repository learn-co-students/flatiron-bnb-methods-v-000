class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

    def neighborhood_openings(start_date, end_date)
      available_listings = []
      unavailable_listings = []

      Reservation.all.each do |reservation|
              unavailable_listings << reservation.listing if reservation.listing.neighborhood == self && overlaps?(start_date, end_date, reservation)
      end

      Listing.all.each do |listing|
          available_listings << listing unless unavailable_listings.include? listing
        end
      available_listings
    end

   def overlaps?(start_date, end_date, other)
      # (start_date - other.checkout) * (other.checkin - end_date) >= 0
      (DateTime.parse(start_date).to_date - other.checkout) * (other.checkin - DateTime.parse(end_date).to_date) >= 0
   end

    def self.most_res
        neighborhood_count = []
          Reservation.all.each do |reservation|
            neighborhood_count << reservation.listing.neighborhood
          end
          freq = neighborhood_count.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
          neighborhood_count.max_by { |v| freq[v] }
       end

    def self.highest_ratio_res_to_listings
        listing_count = {}
        ratios = {}
        neighborhoods = self.reservation_count

        Neighborhood.all.each do |neighborhood|
           listing_count[neighborhood] = 0
           neighborhood.listings.each do |listing|
               listing_count[neighborhood] += 1
           end #listing
                if listing_count[neighborhood] > 0
                  ratios[neighborhood] = neighborhoods[neighborhood] / listing_count[neighborhood]
              end
           end #neighborhood
           ratios.max_by{|k,v| v}[0]
    end

   def self.reservation_count
       neighborhood_count = []
      Reservation.all.each do |reservation|
         neighborhood_count << reservation.listing.neighborhood
      end
      freq =  neighborhood_count.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
   end

end
