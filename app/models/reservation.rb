class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true, uniqueness: true
  validate :guest_and_host_unique, :check_availability, :reservation_order


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
      listing.price * duration
  end

    private
    def guest_and_host_unique
       if self.guest_id == self.listing.host_id
         errors.add(:guest_id, "You can't book your own pad!")
       end
    end

    def check_availability
      self.listing.reservations.each do |r|
        confirmed_dates = r.checkin..r.checkout
        if confirmed_dates === self.checkin || confirmed_dates === self.checkout
          errors.add(:guest_id,
          "I'm sorry, those dates have already been booked.")
        end
      end
    end

    def reservation_order
      if self.checkout && self.checkin
        if self.checkout <= self.checkin
          errors.add(:guest_id, "Checkout date must be after checkin date")
        end
      end
    end
end
