class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  extend Concerns::Popular
  include Concerns::Searchable 
  
  def neighborhood_openings(checkin_day, checkout_day)
    find_availability(self, checkin_day, checkout_day)
  end
end
