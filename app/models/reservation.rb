class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review
  has_one :host, through: :listing

  validates :checkin, :checkout, presence: true

  validate :guest_isnt_host, :checkin_before_checkout, :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private

  def guest_isnt_host
    errors.add(:guest, "You cannot make a reservation on your own listing.") if guest && host.id == guest.id
  end

  def checkin_before_checkout
    if self.checkin && self.checkout && self.checkin >= self.checkout
      errors.add(:checkin, "Checkin cannot be before checkout.")
    end
  end

  # validates that a listing is available at checkin before making reservation
  #  @invalid_checkin = Reservation.new(checkin: '2014-04-26', checkout: '2014-05-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
  #  expect(@invalid_checkin).to_not be_valid

  # validates that a listing is available at checkout before making reservation
  #  @invalid_checkout = Reservation.new(checkin: '2014-04-20', checkout: '2014-04-26', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
  #  expect(@invalid_checkout).to_not be_valid

  # validates that a listing is available at for both checkin and checkout before making reservation
  #  @invalid_checkin_checkout = Reservation.new(checkin:  '2014-04-26', checkout: '2014-04-28', guest_id: User.find_by(id: 4).id, listing_id: Listing.first.id)
  #  expect(@invalid_checkin_checkout).to_not be_valid
  def is_available
    if !valid_date(self.checkin, self.checkout) || !self.checkin || !self.checkout
      errors.add(:checkin, "Listing unavailable.")
    end
  end

  def valid_date(checkin, checkout)
    if self.checkin != nil && self.checkout != nil
      self.listing.reservations.none? { |reservation| (checkin <= reservation.checkout) && (checkout >= reservation.checkin) }
    end
  end

end
