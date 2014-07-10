class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
  end

  # Returns most popular city (most listings)
  def self.most_popular
    
  end

end

