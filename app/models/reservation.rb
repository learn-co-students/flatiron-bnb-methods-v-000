class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :cannot_reserve_your_listing

  validate :listing_available

   def cannot_reserve_your_listing
     listing = Listing.find(listing_id)
     if guest_id.present? && guest_id == listing.host_id
       errors.add(:guest_id, "you cannot reserve your own listing")
     end
   end

   def listing_available
     binding.pry
     self.listing.neighborhood
   end

end
