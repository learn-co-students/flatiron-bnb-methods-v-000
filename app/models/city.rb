class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        start_date <= reservation.checkout.to_s && end_date >= reservation.checkin.to_s
      end
    end
  end

  def self.most_res
    cities_with_reservations = {}
    all.each do |city|
      res_counts = city.listings.collect {|listing| listing.reservations.count}
      sum_of_reservations = res_counts.inject(0) {|sum, count| sum + count}
      cities_with_reservations[city] = sum_of_reservations
    end
    cities_with_reservations.max_by {|city, res| res}.first
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |a|
        counter += a.reservations.count
      end
      ratios[city] = (counter)/(city.listings.count)
    end
    ratios.key(ratios.values.sort.last)
  end

end
