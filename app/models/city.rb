class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(startdate, enddate)
    binding.pry
    results = [] 
    self.listings.each do |listing|
      listing.reservations.each do |rsvp|
        results << listing if rsvp.checkin > Date.parse(startdate) && rsvp.checkout < Date.parse(enddate)
      end
    end
    results
  end

# @city.city_openings('2014-05-01', '2014-05-05')

end

