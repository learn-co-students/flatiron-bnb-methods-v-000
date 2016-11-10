class MyValidator < ActiveModel::Validator
    def validate(record)
        unless record.listing.host != record.guest
            record.errors[:guest] << "Can't reserve own listing"
        end
        if !!record.checkin && !!record.checkout
            unless record.checkin < record.checkout
                record.errors[:checkin] << "Checkin must be before checkout"
            end
            unless record.listing.reservations.none? { |r| r.dates.include?(record.checkin) }
                record.errors[:checkin] << "Checkin is already taken"
            end
            unless record.listing.reservations.none? { |r| r.dates.include?(record.checkout) }
                record.errors[:checkout] << "Checkout is already taken"
            end
        end
    end
end
class Reservation < ActiveRecord::Base
    include ActiveRecord::Validations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validates_with MyValidator

  def duration
      self.checkout - self.checkin
  end

  def total_price
      duration * self.listing.price
  end

  def dates
      dates = []
      (duration.to_i).times do |i|
          dates << (self.checkin + i)
      end
      dates
  end

end
