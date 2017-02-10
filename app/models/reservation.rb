class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_shilling?
  validate :no_evictions?
  validate :no_time_traveling?

  # INSTANCE METHODS ARE BELOW

  def duration
    checkout.to_date - checkin.to_date
  end

  def total_price
    duration * listing.price
  end

  # VALIDATION METHODS ARE BELOW

  def no_shilling?
    if guest_id == listing.host_id
      errors.add(:guest_id, "cannot be the same user as the reservation’s listing’s host’s ID.")
    end
  end

  def no_evictions?
    listing.reservations.each do |r|
      if checkin && checkout
      # The conditional above is to avoid erroring out when checkin or checkout is missing
        if r.checkout < checkin.to_date || r.checkin > checkout.to_date
        else
          errors.add(:checkin, "cannot occur during an existing reservation.")
        end
      end
    end
  end

  def no_time_traveling?
    if checkin && checkout
      if checkin.to_date >= checkout.to_date
        errors.add(:checkin, "must be before checkout.")
      end
    end
  end

end
