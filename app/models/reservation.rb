class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :cannot_reserve_your_listing

  validate :listing_available

  validate :checkout_before_checkin

  def duration
    dur = checkout - checkin
    dur.to_i
  end

  def total_price
    listing.price.to_f*duration
  end

  private

   def cannot_reserve_your_listing
     listing = Listing.find(listing_id)
     if guest_id.present? && guest_id == listing.host_id
       errors.add(:guest_id, "you cannot reserve your own listing")
     end
   end

   def listing_available
     if self.status != "accepted" && self.checkin && self.checkout && self.listing.neighborhood && !self.listing.neighborhood.neighborhood_openings(checkin, checkout).include?(self.listing)
       errors.add(:reservation, "listing is not available")
    end
   end

   def checkout_before_checkin
     if self.status != "accepted" && self.checkin && self.checkout && checkout <= checkin
       errors.add(:reservation, "checkout cannot happen before or on the same day as checkin")
     end
   end




end
