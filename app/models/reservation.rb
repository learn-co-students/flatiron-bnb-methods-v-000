class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_listing
  validate :listing_available_checkin
  validate :listing_available_checkout
  validate :checkin_after_checkout

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.duration * listing.price.to_i
  end

  private

  def own_listing
    if listing.host == guest
      errors.add(:own_listing, "can't be a guest at your own listing.")
    end
  end

  def listing_available_checkin
    if checkin != nil
      listing.reservations.each do |reservation|
        if self.checkin >= reservation.checkin && self.checkin <= reservation.checkout
          errors.add(:listing_taken, "Listing is not available on checkin date.")
        end
      end
    end
  end

  def listing_available_checkout
    if checkout != nil
      listing.reservations.each do |reservation|
        if self.checkout >= reservation.checkin && self.checkout <= reservation.checkout
          errors.add(:listing_taken, "Listing is not available on checkin date.")
        end
      end
    end
  end

  def checkin_after_checkout
    if checkin != nil && checkout != nil
      if checkin >= checkout
        errors.add(:checkin_after_checkout, "Checkin must be before checkout.")
      end
    end
  end
end
