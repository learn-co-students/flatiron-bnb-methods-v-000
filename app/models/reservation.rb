class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :val
  def val
    if guest==listing.host then errors.add(:guest, "same as host") end
    if checkin!=nil and checkout!=nil and checkin>=checkout then errors.add(:checkout, "must be later than checkin") end
    listing.reservations.each do |r|
      if r!=self and checkin!=nil and r.checkin<=checkin and r.checkout>=checkin then errors.add(:checkin, "invalid") end
      if r!=self and checkout!=nil and r.checkin<=checkout and r.checkout>=checkout then errors.add(:checkout, "invalid") end
    end
  end
  def duration
    checkout-checkin
  end
  def total_price
    duration*listing.price
  end

end
