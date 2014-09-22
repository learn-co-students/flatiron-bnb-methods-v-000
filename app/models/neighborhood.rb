class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # Returns all of the available apartments in a neighborhood, given the date range
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
    return openings
  end

  # Returns nabe with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    popular_nabe = Neighborhood.create(:name => "There is no popular neighborhood.")
    highest_ratio = 0.00
    self.all.each do |nabe|  
      denominator = nabe.listings.count
      numerator = nabe.find_res_count
      if denominator == 0 || numerator == 0
        next
      else
        popularity_ratio = numerator / denominator
        if popularity_ratio > highest_ratio
          highest_ratio = popularity_ratio
          popular_nabe = nabe
        end
      end
    end
    return popular_nabe
  end

  # Returns nabe with most reservations
  def self.most_res
    most_reservation = "currently unknown"
    total_reservation_number = 0
    self.all.each do |nabe|
      nabe_reservation_number = nabe.find_res_count
      if nabe_reservation_number > total_reservation_number
        total_reservation_number = nabe_reservation_number
        most_reservation = nabe
      end
    end
    return most_reservation
  end

  #helper for above class methods
  def find_res_count
    res_count = 0
    self.listings.each do |listing|
      res_count += listing.reservations.where(:status => "accepted").count
    end
    return res_count
  end

end
