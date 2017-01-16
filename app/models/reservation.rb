class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :host, through: :listing
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :cannot_make_reservation_on_own_listing, :listing_available_at_checkin

  def duration
    checkout - checkin
  end

  def total_price
    self.listing.price * duration
  end


  private

    def cannot_make_reservation_on_own_listing
      if self.guest_id == self.listing.host_id
        errors.add(:reservation, "cannot be made on own listing")
      end
    end

    def listing_available_at_checkin
      self.listing.reservations.any? do |reso|
        checkin <= reso.checkout && checkout >= reso.checkin
        errors.add(:reservation, "can't be made. Listing not available during selected times.")
      end
    end

end
