class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  
  has_many :reservations, through: :listings
  # for us to be able to query for .most_res

  include Reservable

end
