class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_is_not_guest, :checkin_before_checkout, :checkin_not_checkout
  before_validation :available?

  def total_price
    listing.price * duration
  end

  def duration
    checkout - checkin
  end

  private

  def host_is_not_guest
    if self.listing.host_id == self.guest_id
      errors.add(:host_is_not_guest, "You cannot make a reservation on your own listing")
    end
  end

  def checkin_before_checkout
    if checkout && checkin && checkout < checkin
      errors.add(:reservation, "Please try dates again.")
    end
  end

  def checkin_not_checkout
    if checkin == checkout
      errors.add(:reservation, "Please try dates again.")
    end
  end

  def available?
    if checkout && checkin
      listing.reservations.each do |r|
        if r.checkin <= checkout && r.checkout >= checkin
          errors.add(:reservation, "Please try dates again.")
        end
      end
    end
  end


end
