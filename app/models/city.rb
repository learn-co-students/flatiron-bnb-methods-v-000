class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend StatusMethods::ClassMethods
  # include StatusMethods::InstanceMethods

def city_openings(checkin, checkout)
  requested_dates = ((Date.parse(checkin))..(Date.parse(checkout))).collect {|day| day}
  self.listings.select do |listing|
    if listing.dates_occupied
      requested_dates.none?{|date| listing.dates_occupied.include?(date)}
    else
      listing
    end
  end
end



end
