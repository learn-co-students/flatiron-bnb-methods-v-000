class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    first_date = Date.parse(start_date)
    last_date = Date.parse(end_date)

    @available_listings = []

    listings.each do |listing|
      @available_listings << listing 
    end
    
    @available_listings.delete_if do |listing|
      listing.reservations.any? do |reservation|
        first_date.between?(reservation.checkin, reservation.checkout) || last_date.between?(reservation.checkin, reservation.checkout)
      end
    end
    @available_listings
  end

  def self.highest_ratio_res_to_listings
    city_ratios = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |list|
        counter += list.reservations.count
      end
      city_ratios[city] = (counter)/(city.listings.count)
    end
    city_ratios.key(city_ratios.values.sort.last)
  end

  def self.most_res
    city_count = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |list|
        counter += list.reservations.count
      end
      city_count[city] = counter
    end
    city_count.key(city_count.values.sort.last)
  end


end


   