class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    arr = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.available?(start_date, end_date)
          arr << listing
        end
      end
    end
   arr
  end

end
