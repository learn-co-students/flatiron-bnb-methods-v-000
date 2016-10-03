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
    binding.pry
    listing.reservations.each do |r|
      binding.pry
      if checkin.to_s.between?(r.checkin.to_s, r.checkout.to_s)
        errors.add(:reservation, "Reservation is not available for this checkin date")
      end
    end
  end

end
