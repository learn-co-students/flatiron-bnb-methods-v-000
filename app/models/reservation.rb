class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :checkin_before_checkout
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_owner
  validate :not_same_date
  before_validation :availability


  def checkin_before_checkout
    if checkout && checkin && checkout < checkin
      errors.add(:reservation, "Checkout date cant be before checkin date.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end


private

    def not_owner
     if guest_id == listing.host_id
       errors.add(:reservation, "You cannot book your own listing.")
      end
    end


     def not_same_date
      if checkin == checkout
        errors.add(:reservation, "Dates can't be the same.")
      end
    end

    def availability
      if (checkout && checkin)
        listing.reservations.each do |reservation|
          if reservation.checkin <= checkout && reservation.checkout >= checkin
            errors.add(:reservation, "Check your dates and try again.")
          end
        end
      end
    end
end