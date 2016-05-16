class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

   include RatioQueries

  def city_openings(begin_date, end_date)
    date_range = (Date.parse(begin_date)..Date.parse(end_date))
    listings.collect do |listing|
      available = true
      listing.booked_dates.each do |date|
        if date_range === date
          available = false
        end
      end
      listing if available
    end
 end




end
