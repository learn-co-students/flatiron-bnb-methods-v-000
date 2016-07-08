class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  before_validation :cannot_make_a_reservation_on_your_own_listing
  validate :check_if_listing_is_avaliable_before_making_a_reservation
  validate :checkin_is_before_checkout
  validates :checkin, :checkout, presence: true

  
  def cannot_make_a_reservation_on_your_own_listing
    self.listing.host != self.guest 
  end

  def check_if_listing_is_avaliable_before_making_a_reservation
    self.listing.reservations.each do |res|
      reservation_dates = (res.checkin..res.checkout)
      if reservation_dates === self.checkin || reservation_dates === self.checkout
        errors.add(:guest_id, "No available dates")
      end 
    end
  end

  def checkin_is_before_checkout
    if !checkin || !checkout || checkin > checkout || checkin == checkout
      errors.add(:guest_id)
    end
  end

  def duration
    checkout-checkin
  end

  def total_price
    duration.to_i * (listing.price.to_i)
  end

 end

