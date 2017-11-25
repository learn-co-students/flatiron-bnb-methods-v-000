module Reservable
  extend ActiveSupport::Concern

  # This is super ugly but it works...

  def bad_listing(date1, date2) # returns the listings that are booked for the arguments(dates)
    bad_dates = Reservation.all.where("checkin <= ? AND checkout >= ?", date2, date1)
    bad_dates.collect {|reservation| reservation.id}
  end

  class_methods do

    def highest_ratio_res_to_listings
      self.listing
      self.listing_total
      self.reservations
      self.zip
      self.total
      self.find(@percentages.index(@percentages.max) + 1) # Returns the city by the index of the @city_percentages with the highest ratio
    end

    def most_res
      self.reservations
      self.find(@reservations_total.index(@reservations_total.max) + 1)
    end

    def listing # @listings will be an array of hashes - each hash(city) containing totals of each listings
      @listings = []
      self.all.each do |city_or_nabe|
        @listings << city_or_nabe.listings.group(:neighborhood_id).count
      end
    end

    def listing_total # listings_total is an array with the total listings representing an index(city or nabe)
      @listings_total = []
      @listings.each do |city|
        @listings_total << city.values.sum
      end
    end

    def reservations # @reservations_total will be an array, each index(represents a city or nabe) holds the total number of reservations
      @reservations_total = []
      self.all.each do |city_or_nabe|
        @reservations_total << city_or_nabe.reservations.count
      end
    end

    def zip # merges @reservations_total array and @listings_total
      @res_and_listings_total = @reservations_total.zip @listings_total
    end

    def total # finds the percentages of bookings per city or nabe
      @percentages  = []
      @res_and_listings_total.each do |a, b|
        @percentages << (a.to_f / (b.to_f.nonzero? || 1) * 100)
      end
    end

  end

end
