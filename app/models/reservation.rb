class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :host_not_making_reservation, :checkin_and_checkout_are_available, :checkin_and_checkout_dates_correct

  after_validation :change_status

  extend ArelTables
  include ArelTables

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    50.0*duration
  end

  def self.guests_list
    User.where(id: all.select(:guest_id).distinct.pluck(:guest_id))
  end

  def self.hosts_list
    User.where(id: Listing.where(id: all.select(:listing_id).distinct.pluck(:listing_id)).pluck(:host_id))
  end

  def self.all_reviews
    Review.where(reservation_id: all.pluck(:id))
  end

  private

  def host_not_making_reservation
    errors.add(:guest, "host can't make reservation on own listing.") if guest_id == listing.host_id
  end

  def checkin_and_checkout_are_available
    if checkin.present? && checkout.present? && !self.persisted?
      taken_reservation = listing.reservations.where(reservations_arel[:checkout].gteq(checkin).and(reservations_arel[:checkout].lteq(checkout)).or(reservations_arel[:checkin].gteq(checkin).and(reservations_arel[:checkin].lteq(checkout))).or(reservations_arel[:checkin].lteq(checkin).and(reservations_arel[:checkout].gteq(checkout))))
      errors.add(:base, "reservation dates are unavailable.") unless taken_reservation.empty?
    end
  end

  def checkin_and_checkout_dates_correct
    if checkin.present? && checkout.present?
      if checkin == checkout
        errors.add(:base, "check-in and checkout dates can't be the same.")
      else
        errors.add(:base, "checkout date can't be before check-in date.") if checkin > checkout
      end
    end  
  end

  def change_status
    status = "accepted"
  end

end