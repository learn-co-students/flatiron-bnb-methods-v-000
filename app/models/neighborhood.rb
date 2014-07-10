class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # Returns all of the available apartments in a neighborhood, given the date range
  def neighorhood_openings(start_date, end_date)
  end

  # Returns most popular neighborhood (most listings)
  def self.most_popular
    
  end

end
