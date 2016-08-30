class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :no_reservation_on_own_listing
  validate :available_at_checkin
  validate :checkin_before_checkout, if: :checkin_and_checkout

  def duration
    checkout - checkin
  end

  def total_price
    listing.price.to_f * duration
  end

  protected
  def no_reservation_on_own_listing
    if self.listing.host == self.guest
      errors.add(:guest, "can't be the host")
    end
  end

  def available_at_checkin
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |res|
      res_range = res.checkin..res.checkout
      if res_range === checkin || res_range === checkout
        errors.add(:guest_id, "should be in range")
      end
    end

  end

  def checkin_before_checkout
    if (self.checkin > self.checkout) || (self.checkin == self.checkout)
      errors.add(:checkin, "should be before checkout")
    end
  end

  def checkin_and_checkout
    self.checkin && self.checkout
  end


end
