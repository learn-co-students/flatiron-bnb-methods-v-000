class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  extend Concerns::Popular
  
  def city_openings(checkin_day, checkout_day) 
    if Date.parse(checkin_day) <= Date.parse(checkout_day)
      new_checkin = Date.parse(checkin_day)
      new_checkout = Date.parse(checkout_day)
      available_listings = []
      self.listings.each do |listing|
        available = true
        listing.reservations.each do |res|
          checkin = res.checkin
          checkout = res.checkout
          # checks if the new checkin date is in the middle
          # of the current reservation, then checks if the
          # new checkout date is in the middle of the
          # current reservation, if either is the case 
          # the listing is set to unavailable
          if (checkin < new_checkin && new_checkin < checkout) || (checkin < new_checkout && new_checkout < checkout)
            available = false
          end
        end
        # After all potentially conflicting reservations
        # have been checked, the listing is added if 
        # it is available
        available_listings << listing if available
      end
      available_listings.uniq
    else
      "Please enter a checkin day that is before your checkout day"
    end
  end
end

