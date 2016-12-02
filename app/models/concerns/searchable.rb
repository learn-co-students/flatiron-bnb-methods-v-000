module Concerns::Searchable 
  def find_availability(area, checkin_day, checkout_day)
    if Date.parse(checkin_day) <= Date.parse(checkout_day)
      available_listings = []
      area.listings.each do |listing|
        if listing_available?(listing, checkin_day, checkout_day)
          available_listings << listing 
        end
      end
      available_listings.uniq
    else
      "Please enter a checkin day that is before your checkout day"
    end
  end
  
  def listing_available?(listing, checkin_day, checkout_day)
    if checkin_day.class != Date
      new_checkin = Date.parse(checkin_day)
    else
      new_checkin = checkin_day
    end 
    if checkout_day.class != Date
      new_checkout = Date.parse(checkout_day) 
    else 
      new_checkout = checkout_day 
    end
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
    available
  end
  
end