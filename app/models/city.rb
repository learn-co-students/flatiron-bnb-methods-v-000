class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # def city_openings(checkin, checkout)
  #   arr = []
  #   self.listings.each do |listing|
  #     if listing.reservations.available?(checkin, checkout)
  #       arr << listing
  #     end
  #   end
  #   arr
  # end

  def city_openings
  end

end
