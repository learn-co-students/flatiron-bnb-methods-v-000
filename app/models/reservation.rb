class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :checkin_before_checkout
  validate :host_isnt_guest
  validate :available?

  def duration
    checkout - checkin
  end

  def total_price
    duration * self.listing.price
  end

  private

  def available?
    unless available(checkin, checkout)
      errors.add(:checkin, "There must be an available listing at checkin and checkout")
    end
  end

  def available(checkin, checkout)
    checkin_and_checkout_present && listing.reservations.none? do |reservation|
       (checkin <= reservation.checkout) && (checkout >= reservation.checkin)
     end
   end

  def checkin_before_checkout
   unless checkin_and_checkout_present && checkin < checkout
     errors.add(:checkin, "Checkin must be before checkout")
   end
  end

  def checkin_and_checkout_present
    !checkin.nil? && !checkout.nil?
  end

  def host_isnt_guest
    if self.listing.host_id == guest_id
      errors.add(:guest, "Host cannot be guest")
    end
  end



end
