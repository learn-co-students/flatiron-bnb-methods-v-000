class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout, :status
  validate :not_same_host_and_guest
  validate :check_availibility
  validate :date_verification

  def not_same_host_and_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "The host and guest can not be the same")
    end
  end

  def check_availibility
    if !checkin.nil? && !checkout.nil?
      listing.reservations.each do |r|
        errors.add(:checkin, "This date is not available, please reselect") if checkin >= r.checkin && checkin <= r.checkout
        errors.add(:checkout, "This date is not available, please reselect") if checkout >= r.checkin && checkout <= r.checkout
      end
    end
  end

  def date_verification
    if !checkin.nil? && !checkout.nil?
      errors.add(:checkin, "Checkin must be at least one day before checkout.") if checkin >= checkout
    end
  end

  def duration
    duration = checkout - checkin
  end

  def total_price
    total_price = duration * listing.price
  end

end
