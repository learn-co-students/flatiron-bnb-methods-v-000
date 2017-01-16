class City < ActiveRecord::Base

  include Reportable::InstanceMethods
  extend Reportable::ClassMethods


  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin, checkout)
    openings(checkin, checkout)
  end


  



  #self.all.max_by { |c| c.listings.count == 0 ? 0 : c.reservations.count / c.listings.count }


 
end

