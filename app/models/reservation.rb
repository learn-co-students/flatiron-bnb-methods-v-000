class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :own_listing?
  validate :valid_checkout_time?
  validate :unique_reservation?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def own_listing?
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot reserve your own listing")
    end
  end

  def unique_reservation?
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      rsvp_dates = r.checkin..r.checkout
       if rsvp_dates.include?(checkin) || rsvp_dates.include?(checkout)
         errors.add(:guest_id, "This listing is not available during your requested dates.")
       end
     end
   end

  def valid_checkout_time?
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Your checkin date needs to be before your checkout date.")
    end
  end
end
