class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  extend Concerns::Popular
  include Concerns::Searchable
  
  def city_openings(checkin_day, checkout_day) 
    find_availability(self, checkin_day, checkout_day)
  end
end

