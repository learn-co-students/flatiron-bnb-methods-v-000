class MyValidator < ActiveModel::Validator
  def validate(record)
    host = User.find_by_id(Listing.find_by_id(record.listing_id).host_id)
    guest = User.find_by_id(record.guest_id)
    if host == guest
      record.errors[:available] << 'This is your own listing!'
    end
  end
end

class Reservation < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with MyValidator

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :correct_dates
  validate :invalid_dates

  def invalid_dates
    reservations = self.listing.reservations

    if !reservations.empty? && checkin && checkout && status != "accepted"
      reservations.each do |reservation|
        range = reservation.checkin..reservation.checkout
        if range.include?(checkin.to_date) || range.include?(checkout.to_date)
          errors[:availability] << "Not available during this time."
        end
      end
    end
  end

  def correct_dates
    if checkin && checkout
      if checkin > checkout
        errors[:availability] << "Checkin must be before checkout"
      end

      if checkin == checkout
        errors[:availability] << "Checkin cannot be the same as checkout."
      end
    end
  end


  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price.to_i
  end

end
