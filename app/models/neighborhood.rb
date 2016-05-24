class Neighborhood < ActiveRecord::Base
  #include ReservationRatios
  belongs_to :city
  has_many :listings

  
end
