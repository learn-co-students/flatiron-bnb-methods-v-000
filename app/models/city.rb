class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    openings = []
    Listing.all.each do |list|
      list.reservations.each do |reservation|
        if !(start_date.to_datetime <= reservation.checkout.to_datetime) and !(end_date.to_datetime >= reservation.checkin.to_datetime)
          openings << list
        end
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
  end

  def self.most_res
  end

end
