class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :no_self_reservation
  validate :listing_available, on: :create
  validate :checkin_before_checkout

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price
  end

  def checked_out?
    Time.now > self.checkout
  end

  private

    def no_self_reservation
      if self.listing.host == self.guest
        self.errors.add(:guest, "cannot be the host")
      end
    end

    def listing_available
      if self.checkin && self.checkout
        unless self.listing.available?(self.checkin, self.checkout)
          self.errors.add(:listing, "is not available for the dates given")
        end
      end
    end

    def checkin_before_checkout
      if self.checkin && self.checkout && self.checkin >= self.checkout
        self.errors.add(:checkout, "must be after checkin")
      end
    end
end
