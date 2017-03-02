class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, absence: false
  validate :checkin_qualities
  validate :host_qualities
  validate :available

  def checkin_qualities
    if checkin && checkout
      if checkout < checkin
        errors.add(:checkout, "must occur after checkin date")
      elsif checkout == checkin
        errors.add(:checkout, "cannot occur on the same day as checkin")
      end
    else
      errors.add(:checkin, "must list both a checkin and checkout date")
    end
  end

  def host_qualities
    if listing.host == guest
      errors.add(:guest, "cannot be a guest of your own listing")
    end
  end

  def available
    if self.status != "accepted"
      errors.add(:listing_not_available, "reservations can only be made for available listings")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * self.listing.price
  end
end
