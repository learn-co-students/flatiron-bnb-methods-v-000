class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :available, :guest_and_host_not_same, :checkin_before_checkout

  # def make_date_from_str(str)
  #   Date.new(*str.split("-").map { |el| el.to_i })
  # end

  def duration
    checkout.day - checkin.day
  end

  def total_price
    self.duration * self.listing.price
  end

  private

    def available
      unless self.checkin && self.checkout && self.listing.available?(self.checkin, self.checkout)
        errors.add(:guest_id, "Reservation is not available for these dates!")
      end
    end

    def guest_and_host_not_same
      if guest && listing.host && (guest.id == listing.host.id)
        errors.add(:guest_id, "You can't book your own listing")
      end
    end

    def checkin_before_checkout
      if self.checkout && self.checkin && self.checkin >= self.checkout
        errors.add(:guest_id, "Checkin date can't be later than checkout date!")
      end
    end
end
