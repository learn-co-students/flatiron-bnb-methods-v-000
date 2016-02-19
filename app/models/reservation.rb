class ResValidator < ActiveModel::Validator
  def validate(record)
    if record.guest == record.listing.host
      record.errors[:guest] << "Hosts cannot reserve their own listing!"
    end


    i = record.checkin
    o = record.checkout
    unless i.nil? || o.nil?
      record.errors[:checkin] << "Check-in cannot be on or before check-out!" if i >= o

      Reservation.all.each { |res|
        if res.checkin.between?(i, o) || res.checkout.between?(i, o) || (res.checkin < i && res.checkout > o)
          record.errors[:checkin] << "Dates not available!"
          #binding.pry
        end
      }
    end
  end
end

class Reservation < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates :checkin, :checkout, presence: true
  validates_with ResValidator
  #binding.pry
  #validates_with DatesValidator
  #before_save :dates_available?

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end
  private

end
