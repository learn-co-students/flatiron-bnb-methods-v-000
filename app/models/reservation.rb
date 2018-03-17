class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_and_guest_not_same, :dates_not_same, :checkin_before_checkout, :is_available



  def total_price
    duration * listing.price
  end

  def duration
    (checkout - checkin).to_i
  end

  def host_and_guest_not_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def dates_not_same
    if checkin == checkout
      errors.add(:guest_id, "You can't checkin and checkout on the same date")
    end
  end

  def is_available
    if checkin && checkout
      listing.reservations.each do |r|
        if r.checkin <= checkout && r.checkout >= checkin
          errors.add(:reservation, "These dates are not available")
        end
      end
    end
  end
  def checkin_before_checkout
    if checkout && checkin && checkout < checkin
      errors.add(:guest_id, "Sorry your checkout date must be after the checkin date")
    end
  end
end
