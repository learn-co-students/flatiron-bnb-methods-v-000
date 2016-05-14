class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :guest_not_host, on: :create
  validate :listing_availible?
  validate :checkin_before_checkout
  validate :checkout_different_from_checkin

  def guest_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest, "Host's can't reservere there own listings.")
    end
  end

  def checkin_before_checkout

    if checkin && checkout && checkout < checkin &&
      errors.add(:checkout, "Must be after checkin")
    end

  end

  def checkout_different_from_checkin
    if checkout == checkin
      errors.add(:checkout, "Must be different from checkin")
      errors.add(:checkin, "Must be different from checkout")

    end
  end

  def listing_availible?
    if self.checkin && self.checkout
      if self.listing.listing_reserved?(checkin, checkout)
        errors.add(:checkin, "reserved")
      end
    else
      errors.add(:checkin, "oops")
    end
  end

  def checkin_date
    self.checkin.strftime("%F")
  end

  def checkout_date
    self.checkout.strftime("%F")
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
