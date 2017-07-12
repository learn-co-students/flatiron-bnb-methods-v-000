class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :no_reserve_on_own_listing, :reserved, :checkout_after_checkin

  def duration
    day = 0
    while self.checkin < self.checkout do
      self.checkin += 1
      day += 1
   end
   day
  end

  def total_price
    duration * listing.price
  end

  private

  def no_reserve_on_own_listing
    listing = Listing.find(listing_id)
    host = User.find(listing.host_id)
    if host.id == self.guest_id
      errors.add(:guest_id, "can't be a guest where you host")
    end
  end

  def reserved
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkout_after_checkin
   if checkout && checkin && checkout <= checkin
    errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end
end
