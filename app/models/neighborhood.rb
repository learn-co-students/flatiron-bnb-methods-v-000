class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    openings = []
    self.city.city_openings(start_date, end_date).each do |opening|
      if opening.neighborhood == self
        openings << opening
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    ratio_array = [0]
    Neighborhood.all.each do |neighborhood|
      reservation_count = 0.0
      neighborhood.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      ratio = reservation_count / neighborhood.listings.count
      if ratio > ratio_array[-1]
        ratio_array = [neighborhood, ratio]
      end
    end
    ratio_array[0]
  end

  def self.most_res
    res_array = [0]
    Neighborhood.all.each do |neighborhood|
      reservation_count = 0.0
      neighborhood.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      if reservation_count > res_array[-1]
        res_array = [neighborhood, reservation_count]
      end
    end
    res_array[0]
  end












end






