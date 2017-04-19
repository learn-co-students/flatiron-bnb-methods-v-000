class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates_presence_of :checkin, :checkout
  validate :not_own_posting
  validate :valid_date_range

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def not_own_posting
    errors.add(:guest, "You cannot be a guest of your own listing") if listing.host == guest
  end

  def valid_date_range
    if checkin && checkout
      if listing.reservations.any? {|res| (checkin <= res.checkout) && (checkout >= res.checkin)}
        errors.add(:guest_id, "Cannot overlap with an existing reservation.")
      elsif checkin >= checkout
        errors.add(:guest_id, "Checkout must be at least one day after checkin")
      end
    end
  end

end
