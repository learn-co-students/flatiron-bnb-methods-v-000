class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include Concerns::Sortable
  include Concerns::Listable

  def city_openings(start_date, end_date)
  	listings.each do |listing|
  		listing.reservations.select do |res|
  			res unless (res.day_lister & trip_day_list(start_date.to_date, end_date.to_date)).any?
  		end
  	end
  end

end

