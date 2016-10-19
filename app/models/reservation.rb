class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  after_validation :own_listing
  before_save :available?


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price
  end

  private

  def available?
    if !self.listing.reservations.empty?
      self.listing.reservations.each do |res|
        if self.checkin.between?(res.checkin, res.checkout) || self.checkout.between?(res.checkin, res.checkout) || res.checkin.between?(self.checkin, self.checkout) || res.checkout.between?(self.checkin, self.checkout)
          errors.add(:listing_id, "already booked")
        end
      end
    end
  end

  def own_listing
    if self.guest == self.listing.host
       errors.add(:guest_id, "can't book your own listing")
    end
  end

end
