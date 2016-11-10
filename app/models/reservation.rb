class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :host, :through => :listing
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :host_is_not_guest, :listing_is_available

  def duration
    checkout - checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def host_is_not_guest
    if guest && host.id == guest.id
      errors.add(:guest, "host cannot make a reservation on their own listing")
    end
  end

  def listing_is_available
    if !checkin || !checkout || checkin >= checkout || !available(checkin, checkout)
      errors.add(:checkin, "listing is not available for selected dates")
    end
  end

  def available(checkin, checkout)
      self.listing.reservations.none? do |reservation|
        (checkin <= reservation.checkout) && (checkout >= reservation.checkin)
      end
  end

end
