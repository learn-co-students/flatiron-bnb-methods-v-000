class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    available = []
    self.neighborhoods.each do |neighborhood|
      neighborhood.listings.each do |listing|
        listing.reservations.each do |res|
          if !res.checkin.between?(start.to_date, finish.to_date) && !res.checkout.between?(start.to_date, finish.to_date) # && !start.to_date.between?(res.checkin, res.checkout) && !finish.to_date.between?(res.checkin, res.checkout)
            available << res.listing unless available.include?(res.listing)
          end
        end
      end
    end
    available
  end

end
