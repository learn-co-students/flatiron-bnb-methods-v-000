class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(checkin, checkout)
    availables = self.listings.collect{|a| a}
    self.listings.each do |listing|
      listing.reservations.each do |res|
        if (Date.parse(checkin) > res.checkin && Date.parse(checkin) < res.checkout) || (Date.parse(checkout) > res.checkin && Date.parse(checkout) < res.checkout)
          available.delete(listing)
        end
      end
    end
  end

end
