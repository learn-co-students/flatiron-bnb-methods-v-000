class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_reservation
  validate :listing_available?
  validate :checkin_before_checkout?


  def own_reservation
    if listing.host_id == guest_id
      errors.add(:guest, "Error")
    end
  end

  def listing_available?
    if checkin && checkout
      listing.reservations.each do |r|
        if r.checkin <= checkout && r.checkout >= checkin
          errors.add(:reservation, "Error")
        end
      end
    end
  end

  def checkin_before_checkout?
    if checkin && checkout && checkout <= checkin
      errors.add(:reservation, "Error")
    end
  end

  def  duration
    checkout - checkin
  end

  def total_price
    listing.price*duration
  end

end
