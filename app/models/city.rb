class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

    def city_openings
       # self.listings.where( #reservations exist between dates 1 and 2)
    end
end

