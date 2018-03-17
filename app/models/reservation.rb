require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout, :listing

   validate :guest_is_not_host, :listing_available, :checkin_before_checkout, :dates_not_same

  def guest_is_not_host
    if checkin && checkout && listing && guest
      if guest.id == listing.host_id
        errors.add(:guest, "Can't reserve your own listing")
      end
    end
  end

  def listing_available
    #puts "listing_available called"
    if checkin && checkout && listing
      #puts "checkin && checkout && listing"
      if !listing.listing_is_open?(checkin, checkout)
        #puts "WAAAAT from proposed:checkin #{checkin}, checkout #{checkout}"
        errors.add(:listing, "Listing not available")
      else
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && listing
      if checkin > checkout
        errors.add(:checkin, "Checkin must be before checkout")
      end
    end
  end

  def dates_not_same
    if checkin == checkout
      errors.add(:checkout, "Checkout must not equal checkin")
    end
  end



  def duration
  	self.checkout - self.checkin
  end

  def total_price
  	self.duration * self.listing.price
  end


end
