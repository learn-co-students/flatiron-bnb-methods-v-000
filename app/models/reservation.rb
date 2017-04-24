class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: :true
  validates :checkout, presence: :true
  validate :checkin_is_date?
  validate :cannot_reserve_own_listing
  validate :checkin_is_not_checkout
  validate :checkin_before_checkout
  validate :listing_has_conflict

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end


  def checkin_is_date?
    if !checkin.is_a?(Date)
      errors.add(:checkin, 'must be a valid date')
    end
  end

  def checkout_is_date?
    if !checkout.is_a?(Date)
      errors.add(:checkout, 'must be a valid date')
    end
  end

  private

  def cannot_reserve_own_listing
    if self.guest != nil && self.listing != nil
      if self.guest == self.listing.host
        errors.add(:guest, "cannot stay at a property they host.")
      end
    end
  end

  def checkin_is_not_checkout
    if self.checkin != nil && self.checkout != nil
      if self.checkin == self.checkout
        errors.add(:checkin, "and checkout must be different dates.")
        errors.add(:checkout, "and checkin must be different dates.")
      end
    end
  end

  def checkin_before_checkout
    if (self.checkin && self.checkout) && (self.checkin > self.checkout)
      errors.add(:checkout, "must be after checkin.")
    end
  end

  def listing_has_conflict
    if checkin != nil && checkout != nil
      if listing.has_conflict?(checkin, checkout)
        errors.add(:checkin, "date conflicts with another reservation")
        errors.add(:checkout, "date conflicts with another reservation")
      end
    end
  end
end
