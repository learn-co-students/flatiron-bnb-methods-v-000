class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    parse_start = Date.parse(start_date)
    parse_end = Date.parse(end_date)
    openings = []
    listings.each do |listing|
      booked = listing.reservations.any? do |reservation|
        parse_start.between?(reservation.checkin, reservation.checkout) || parse_end.between?(reservation.checkin, reservation.checkout)
      end
      unless booked
      openings << listing
      end
    end
    return openings
  end

  def self.highest_ratio_res_to_listings
    popular_nabe = Neighborhood.create(:name => "There is no popular neighborhood.")
    highest_ratio = 0.00
    self.all.each do |nabe|
      denominator = nabe.listings.count
      numerator = nabe.reservations.count
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

   def self.most_res
    most_reservation = "currently unknown"
    total_reservation_number = 0
    self.all.each do |nabe|
      nabe_reservation_number = nabe.reservations.count
      if nabe_reservation_number > total_reservation_number
        total_reservation_number = nabe_reservation_number
        most_reservation = nabe
      end
    end
    return most_reservation
  end


end
