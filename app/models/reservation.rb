class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  before_validation :guest_is_not_host
  validate :check_availability, :checkin_is_before_checkout

  def guest_is_not_host
    guest_id != listing.host_id
  end

  def check_availability
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
      reserved_dates = r.checkin..r.checkout

      if reserved_dates === checkin || reserved_dates === checkout
        errors.add(:guest_id, "Sorry, these dates are reserved")
      end
    end
  end

  def checkin_is_before_checkout
    checkin_value = checkin <=> checkout
      if checkin_value != -1
        errors.add(:guest_id, "sorry, checkin needs to be before checkout")
      end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * self.duration
  end

end
