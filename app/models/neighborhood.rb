class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
    openings = self.listings.select do |listing|
      listing.reservations.all? do |reservation|
        !reservation.checkin.between?(date1.to_date, date2.to_date) && !reservation.checkout.between?(date1.to_date, date2.to_date)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood|
      number_of_reservations = 0
      number_of_listings = neighborhood.listings.size
      neighborhood.listings.each do |listing|
        number_of_reservations += listing.reservations.size
      end
      if number_of_listings == 0
        0
      else
        ratio = number_of_reservations.fdiv(number_of_listings)
      end
    end
  end

  def self.most_res
    self.all.max_by do |neighborhood|
      number_of_reservations = 0
      neighborhood.listings.each do |listing|
        number_of_reservations += listing.reservations.size
      end
      number_of_reservations
    end
  end
end
