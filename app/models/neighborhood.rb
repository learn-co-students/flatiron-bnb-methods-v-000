class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include Concerns::Sortable
  include Concerns::Listable

  def neighborhood_openings(start_date, end_date)
  	listings.each do |listing|
  		listing.reservations.select do |res|
  			res unless (res.day_lister & trip_day_list(start_date.to_date, end_date.to_date)).any?
  		end
  	end
  end
  			
end
