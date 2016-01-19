class Reservation < ActiveRecord::Base
  #associations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  #validations
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_your_listing
  validate :listing_available?
  validate :date_order

  
  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  private

  def not_your_listing
    if self.listing.host_id == self.guest_id
      errors.add(:your_listing, "You cannot reserve your own listing.")
    end
  end

  def listing_available?
    if !self.checkin.nil? && !self.checkout.nil?
      
      listing.reservations.each do |reservation|
        reserved = (reservation.checkin..reservation.checkout)
        if reserved === self.checkin || reserved === self.checkout
          errors.add(:unavailable, "The dates you tried to reserve are unavailable")
        end
      end
    end
  end


  def date_order
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:date_error, "Your check-in is before your check-out")
      end
    end
  end



end
