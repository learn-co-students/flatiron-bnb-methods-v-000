class City < ActiveRecord::Base
    has_many :neighborhoods
    has_many :listings, :through => :neighborhoods

    def city_openings(begin_date, end_date)
        # self.listings.where( #reservations exist between begin_date and end_date)
        begin_date = Date.parse(begin_date)
        end_date = Date.parse(end_date)
        self.listings.collect do |listing|
            listing if listing.reservations.none? do |reservation|
                (reservation.checkin > begin_date && reservation.checkin < end_date) || (reservation.checkout > begin_date && reservation.checkout < end_date)
            end
        end.flatten
    end

    def self.highest_ratio_res_to_listings
        @ratios = self.all.collect do |city|
            reservations = city.listings.collect do |listing|
                listing.reservations
            end.flatten
            [reservations.count.to_f / city.listings.count.to_f, city.id]
        end
        @ratios.sort! {|a,b| b[0] <=> a[0]}
        City.find(@ratios[0][1])
    end

    def self.most_res
        @ratios = self.all.collect do |city|
            reservations = city.listings.collect do |listing|
                listing.reservations
            end.flatten
            [reservations.count, city.id]
        end
        @ratios.sort! {|a,b| b[0] <=> a[0]}
        City.find(@ratios[0][1])
    end
end

