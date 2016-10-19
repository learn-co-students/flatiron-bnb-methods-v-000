class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_listing
  validate :available


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price
  end

  def available
    res = Reservation.where(listing_id: listing.id)
    if checkin && checkout
      res.each do |r|
        if id == r.id
          break
        elsif checkin.between?(r.checkin, r.checkout) || checkout.between?(r.checkin, r.checkout)
          errors.add(:guest_id, "Not available")
        elsif checkout <= checkin
          errors.add(:guest_id, "Can't checkin before you checkout")
        end
      end
    end
  end

  def own_listing
    if self.guest == self.listing.host
       errors.add(:guest_id, "Can't book your own listing")
    end
  end

end
