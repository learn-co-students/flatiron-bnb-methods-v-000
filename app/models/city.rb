require 'pry'

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

# binding.pry

  def city_openings
    openings=[]
    # binding.pry
    Reservation.all.each do |reservation|
        city = reservation.listing.neighborhood.city
        if self == city

        end
    end
  end

 def overlaps?(start_date, end_date, other)
    (start_date - other.checkout) * (other.checkin - end_date) >= 0
 end

end

