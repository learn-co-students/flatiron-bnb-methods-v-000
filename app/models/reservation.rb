class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :dates_are_valid?, :cannot_reserve_own_listing, :dates_are_available?



  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

  private

  def dates_are_valid?
    if checkin.nil?
      errors.add(:checkin, "cannot be blank")
    elsif checkout.nil?
      errors.add(:checkout, "cannot be blank")
    elsif
       checkin > checkout || checkin==checkout || checkin.nil? || checkout.nil?
      errors.add(:checkin, "is invalid")
      errors.add(:checkout, "is invalid")
    end
  end

  def cannot_reserve_own_listing
    if self.guest_id == Listing.find(self.listing_id).host_id
      errors.add(:guest_id, "Cannot reserve your own listing!")
    end
  end

  def dates_are_available?
    if !self.listing.reservations.nil?
    self.listing.reservations.each do |res|
      if (res.checkin..res.checkout).include?(checkin)|| (res.checkin..res.checkout).include?(checkout)
        errors.add(:reservation, 'date not available')
      end
   end
 end
  end
end
