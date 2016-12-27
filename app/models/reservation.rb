class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :cannot_make_resevation_on_own_name
  validate :checkin_is_available

  def cannot_make_resevation_on_own_name
    if self.guest == self.listing.host
      errors.add(:cannot_make_resevation_on_own_name, "can not make reservation on own name!")
    end
  end

  def checkin_is_available
    binding.binding.pry
    query_range = self.checkin..self.checkout
    if listing.reservations.any? do |listing|
        range = listing.checkin..listing.checkout
        range.overlaps?(query_range)
      end
      errors.add(:checkin_is_available, "checkin time is not available!")
    end
  end


end
