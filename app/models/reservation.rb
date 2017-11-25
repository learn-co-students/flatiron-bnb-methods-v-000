class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_before_checkout
  validate :guest_not_host
  validate :reservation_available
  include Stats::InstanceMethods

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def checkin_before_checkout
    if checkin && checkout && (checkin >= checkout)
      errors.add(:checkin, "has to be after the checkout date.")
    end
  end

  def guest_not_host
    if guest == listing.host
      errors.add(:guest, "can not be the same as the host.")
    end
  end

  def reservation_available
    if checkin && checkout && !!res_overlap?(checkin, checkout)
      errors.add(:listing, "is not available for the selected dates")
    end
  end

end
