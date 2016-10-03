class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_own_reservation?
  validate :listing_available_at_checkin?

  def not_own_reservation?
    if self.listing.host_id == self.guest_id
      errors.add(:reservation, "Can not reserve your own listing")
    end
  end

  def listing_available_at_checkin?
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
      if checkin.to_s.between?(r.checkin.to_s, r.checkout.to_s)
        errors.add(:checkin, "Reservation is not available for this checkin date")
      end
    end
  end

end
