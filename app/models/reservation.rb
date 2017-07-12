class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: "User"
  has_one :review
  has_one :host, through: :listing

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_validation
  validate :available

  def host_validation
    if listing.host == guest
      errors.add(:guest, "you cannot be a guest of your own listing")
    end
  end

  def available
    if self.status != "accepted"
      errors.add(:listing_not_available, "reservation cannot be made because listing is not available.")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

end
