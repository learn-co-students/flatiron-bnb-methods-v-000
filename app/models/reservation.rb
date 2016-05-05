class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :is_host?, :checkin_first, :available?

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private
  def is_host?
    if listing.host_id == guest_id
      errors.add(:guest_id, "You cannot make a reservation on your own listing")
    end
  end

#review
  def available?
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |res|
      booked = res.checkin..res.checkout
      if booked === checkin || booked === checkout
        errors.add(:guest_id, "This property is booked")
      end
    end
  end

  def checkin_first
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, "Check your checkin/checkout date")
    end
  end
end
