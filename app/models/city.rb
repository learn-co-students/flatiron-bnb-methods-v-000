class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include LocationQuerys
  extend LocationQuerys::ClassMethods
  
  def city_openings(begin_date,end_date)
    self.listings.collect do |listing|
      if !listing.listing_reserved?(begin_date, end_date)
          listing
      end
    end
  end

end
