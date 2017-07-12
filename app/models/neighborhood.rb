class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

 def neighborhood_openings(start_date, end_date)
    openings = []
    self.listings.each do |listing|
      listing.reservations.each do |r|
        booked_dates = r.checkin..r.checkout
        unless booked_dates === start_date || booked_dates === end_date
          openings << listing
        end
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
  popular_neighborhood = Neighborhood.create(:name => "Womp Womp.")
  highest_ratio = 0.00
  self.all.each do |neighborhood|
    denominator = neighborhood.listings.count
    numerator = neighborhood.find_reservation_count
    if denominator == 0 || numerator == 0
      next
    else
      popularity_ratio = numerator / denominator
      if popularity_ratio > highest_ratio
        highest_ratio = popularity_ratio
        popular_neighborhood = neighborhood
      end
    end
  end
  popular_neighborhood
  end

  def find_reservation_count
    reservation_count = 0
    self.listings.each do |listing|
      reservation_count += listing.reservations.where(:status => "accepted").count
    end
    reservation_count
  end

  def self.most_res
    most_reservations = "currently unknown"
    total_reservation_number = 0
    self.all.each do |neighborhood|
      neighborhood_reservation_number = neighborhood.find_reservation_count
      if neighborhood_reservation_number > total_reservation_number
        total_reservation_number = neighborhood_reservation_number
        most_reservations = neighborhood
      end
    end
    most_reservations
  end
end
