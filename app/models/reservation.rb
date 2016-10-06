require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # validates_presence_of :checkin, :checkout, :listing

  # validate :guest_is_not_host, :listing_available

  # def guest_is_not_host
  #   if checkin && checkout && listing && guest
  #     if guest.id == listing.host_id
  #       errors.add(:guest, "Can't reserve your own listing")
  #     end
  #   end
  # end

  # def listing_available
  #   if checkin && checkout && listing
  #     listing.listing_open?(checkin, checkout)
  #   end
  # end



  def duration
  	self.checkout - self.checkin
  end

  def total_price
  	self.duration * self.price
  end


end
