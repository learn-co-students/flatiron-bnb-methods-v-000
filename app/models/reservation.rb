class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_shilling?
  validate :no_evictions?
  validate :no_time_traveling?

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
    if checkin & checkout
      if checking.to_date > checkout.to_date
        errors.add(:checkin, "cannot occur after checkout.")
      end
    end
  end

end
