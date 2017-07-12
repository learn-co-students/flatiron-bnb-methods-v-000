class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :check_if_own
  validate :checkin_before_checkout?
  validate :same_day
  validate :check_available

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  def empty_checkin_or_checkout
    self.checkin == nil || self.checkout == nil
  end

  def check_available
    if empty_checkin_or_checkout
      false
    else
      Reservation.where(listing_id: listing.id).where.not(id: id).each do |reservation|
        if (reservation.checkin >= self.checkin) && (reservation.checkin <= self.checkout)
          errors.add(:checkin, "Existing Reservation!")
        elsif (reservation.checkout >= self.checkin) && (reservation.checkout <= self.checkout)
          errors.add(:checkin, "Existing Reservation!")
        elsif (self.checkin >= reservation.checkin) && (self.checkin <= reservation.checkout)
          errors.add(:checkin, "Existing Reservation!")
        elsif (self.checkout >= reservation.checkin) && (self.checkout <= reservation.checkout)
          errors.add(:checkin, "Existing Reservation!")
        else
          true
        end
      end
    end
  end

  def check_if_own
    if self.listing.host == self.guest
      errors.add(:guest, "Guest can't be host!")
    end
  end

  def checkin_before_checkout?
    if empty_checkin_or_checkout
      false
    else
      if self.checkin > self.checkout
        errors.add(:checkin, "Checkin can't be before Checkout!")
      end
    end
  end

  def same_day
    if empty_checkin_or_checkout
      false
    else
      if self.checkin == self.checkout
        errors.add(:checkin, "Checkin can't be the same as Checkout!")
      end
    end
  end

end
