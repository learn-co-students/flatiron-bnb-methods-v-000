class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review
  has_one :host, through: :listing

  validates :checkin, :checkout, presence: true
  validate :guest_isnt_host, :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def guest_isnt_host
    errors.add(:guest, "You cannot make a reservation on your own listing.") if guest && host.id == guest.id
  end

  def is_available

  end
end
