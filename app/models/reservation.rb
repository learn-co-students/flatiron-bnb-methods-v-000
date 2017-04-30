class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :reservation_valid?

  def reservation_valid?
    return false if checkin.nil? || checkout.nil?

    if guest_id == listing.host_id
      errors.add(:guest, 'cannot make a reservation at your own listing')
    end

    unless listing.available?(checkin, checkout)
      errors.add(:listing, 'is unavailable for those dates')
    end

    unless checkin < checkout
      errors.add(:checkout, 'must be after checkin!')
    end

  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price.to_f * duration
  end

end
