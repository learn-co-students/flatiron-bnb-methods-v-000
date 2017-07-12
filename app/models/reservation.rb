class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :guest_and_host_cannot_be_the_same_user, :checkin_must_be_before_checkout, :reservation_dates_cannot_conflict

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration.to_f * self.listing.price
  end

  def guest_and_host_cannot_be_the_same_user
    if self.guest == self.listing.host
      errors.add(:guest, "can't be the same as the listing host")
    end
  end

  def checkin_must_be_before_checkout
    if checkin && checkout
      unless checkin < checkout
        errors.add(:checkin, "can't be on the same day or after checkout")
      end
    end
  end

  def reservation_dates_cannot_conflict
    if checkin && checkout && !listing.reservations.empty?
      if listing.reservations.any? {|x| x.status == "accepted" && x.id != id && 
         overlap([checkin, checkout], [x.checkin, x.checkout])}
        errors.add(:checkin, "cannot conflict with other reservations")
      end
    end
  end

  private

  def overlap(date_range_one, date_range_two)
    !(date_range_one[0] >= date_range_two[1] || date_range_one[1] <= date_range_two[0])
  end

end
