class City < ActiveRecord::Base
  include Cityhoods
  extend ClassMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings 



  def city_openings(in_date, out_date)
  	self.openings(in_date, out_date)
  end

end

