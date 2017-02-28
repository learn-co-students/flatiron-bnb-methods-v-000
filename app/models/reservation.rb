class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review
  has_one :host, through: :listing
  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host, :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  private

  def guest_is_not_host
    errors.add(:guest, 'cannot make a reservation on your own listing') if guest && host.id == guest.id
  end

  def is_available
    if !checkin || !checkout || checkin >= checkout || !available(checkin, checkout)
      errors.add(:checkin, 'listing is not available for selected dates')
    end
  end

  def available(checkin, checkout)
    listing.reservations.none? do |reservation|
      (checkin <= reservation.checkout) && (checkout >= reservation.checkin)
    end
  end

end
