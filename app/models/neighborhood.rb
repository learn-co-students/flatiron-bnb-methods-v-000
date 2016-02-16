class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include Concerns::Sortable

  def neighborhood_openings(start_date, end_date)
  	listings.each do |listing|
  		listing.reservations.select do |res|
  			res unless (res.day_lister(res.duration, res.checkin) & [start_date, end_date]).any?
  		end
  	end
  end
  			
end
