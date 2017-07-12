class Reservation < ActiveRecord::Base
  validates :checkin, :checkout, presence: true
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :own_listing, :availability, :checkin_before_checkout


  def own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "Nope.")
    end
  end

  def availability
    listing.reservations.where.not(id: id).each do |res|
      taken_dates = res.checkin..res.checkout
      if taken_dates === checkin || taken_dates === checkout
        errors.add(:guest_id, "Not available")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, "Checkin before Checkout")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
