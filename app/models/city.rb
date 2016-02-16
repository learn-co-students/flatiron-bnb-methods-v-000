class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include Concerns::Sortable

  def city_openings(start_date, end_date)
  	listings.each do |listing|
  		listing.reservations.select do |res|
  			res unless (res.day_lister(res.duration, res.checkin) & [start_date, end_date]).any?
  		end
  	end
  end

end

