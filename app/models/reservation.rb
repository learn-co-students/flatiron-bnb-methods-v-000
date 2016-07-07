class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :check_if_user_and_guest_are_the_same, :checkout_is_after_the_checkin

  def check_if_user_and_guest_are_the_same
    self.listing.host == self.guest
  end

  def checkout_is_after_the_checkin
    self.checkin < self.checkout
  end

  def self.check_reservations_by_city
    binding.pry
  end

end
