class Neighborhood < ActiveRecord::Base
  include Reservable
  belongs_to :city
  has_many :listings

  

end
