class Reservation < ActiveRecord::Base
  validates :checkin, :checkout, presence: true
  validate :guest_is_not_host, :checkin_is_before_checkout
  validate :listing_is_available, on: :create
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  scope :contains_dates, ->(first, last) { where('checkin <= ? AND checkout >= ?', last, first) }

  def guest_is_not_host
    if guest_id == listing.host_id
      errors.add(:guest, "can't be a guest at your own listing")
    end
  end

  def checkin_is_before_checkout
    return unless checkin && checkout
    if checkin >= checkout
      errors.add(:checkin, "can't be after checkout")
    end
  end

  def listing_is_available
    unless listing.available?(checkin, checkout)
      errors.add(:listing, "is not available")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end
end
