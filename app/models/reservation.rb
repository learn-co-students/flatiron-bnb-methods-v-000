class GoodReservations < ActiveModel::Validator
  def validate(record)
    if record.listing.host_id == record.guest_id
      record.errors[:guest_id] << "Guest cannot be same user as Host"
    end

    unless record.checkin.nil? || record.checkout.nil?
      if record.listing.reservations.any?{|r| r.checkin <= record.checkin && r.checkout >= record.checkin}
        record.errors[:checkin] << "This listing is already booked for this date"
      end

      if record.listing.reservations.any?{|r| r.checkin <= record.checkout && r.checkout >= record.checkout}
        record.errors[:checkout] << "This listing is already booked for this date"
      end

      if record.checkin >= record.checkout
        record.errors[:checkin] << "Checkin must be before checkout date"
      end
    end


  end
end

class Reservation < ActiveRecord::Base
  include ActiveModel::Validations

  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :status, presence: true
  validates_with GoodReservations
  
  after_save :status_toggle

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def available(date)
    false unless self.listing.neighborhood.openings
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

  private 

    def status_toggle
      self.status == "accepted"
    end

end
