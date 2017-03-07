class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :checkin_before_checkout
  validate :host_isnt_guest

  before_save :validate_checkin_availability

  def duration
    checkout - checkin
  end

  def total_price
    duration * self.listing.price
  end

  private

  def validate_checkin_availability
    listing.reservations.none? do |reservation|
       checkin <= r.checkout
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
