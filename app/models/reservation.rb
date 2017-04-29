class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true

  validate :not_the_same
  validate :available, :checkin_before_checkout, :checkin_not_checkout

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    (duration * listing.price).to_f
  end

  private

  def not_the_same
    if self.listing_id == self.guest_id
      errors.add(:guest_id, "You can't book your own place.")
    end
  end

  def available
    not_available = listing.reservations.map {|x| (x.checkin...x.checkout).to_a}.flatten
    if not_available.include?(checkin)
      errors.add(:checkin, "The room is already booked on that checkin date.")
    elsif not_available.include?(checkout)
      errors.add(:checkout, "The room is already booked on that checkout date.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkout < checkin
      errors.add(:checkout, "The checkout date cannot be before the checkin date.")
    end
  end

  def checkin_not_checkout
    if checkin && checkout && checkout == checkin
      errors.add(:checkout, "The checkout date cannot be the same as the checkin date.")
    end
  end

end
