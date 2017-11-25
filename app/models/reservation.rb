class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_not_guest, :out_before_in, :available?

  def duration
    (checkout - checkin).to_i
    #(self.checkout.strftime('%s').to_i - self.checkin.strftime('%s').to_i) / 86400
  end

  def total_price
    self.duration * self.listing.price
  end

  def out_before_in
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your check out date needs to be before your check in date")
    end
  end

  def host_not_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def available?
    if self.status != "accepted" 
      if self.res_avail? != []
        errors.add(:guest_id, "Those dates are booked")
      end
    end
  end

  def res_avail?
    self.listing.reservations.where("checkin <= ? AND checkout >= ?", self.checkout, self.checkin)
  end

end
