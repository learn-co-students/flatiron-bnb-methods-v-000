class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :also_not_host, :available, :checkin_before_checkout

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def also_not_host
    if guest == listing.host
      errors.add(:guest_id, "Guest cannot also be the host.")
    end
  end

  def available
    listing.reservations.where.not(id: id).each do |res|
      occupied_dates = res.checkin..res.checkout
      if occupied_dates === checkin || occupied_dates === checkout
        errors.add(:guest_id, "Location not available during this time.")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, "Checkin must be before checkout.")
    end
  end

end
