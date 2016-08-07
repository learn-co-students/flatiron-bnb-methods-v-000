class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :check_in, :check_out, presence: true
  validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

  def duration
    (check_out - check_in).to_i
  end

  def total_price
    listing.price * duration
  end

  private


  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.check_in..r.check_out
      if booked_dates === check_in || booked_dates === check_out
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def check_out_after_check_in
    if check_out && check_in && check_out <= check_in
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end

  # belongs_to :listing
  # belongs_to :guest, :class_name => "User"
  # has_one :review
  #
  # validates :check_in, presence: true
  # validates :check_out, presence: true
  #
  # validate :cannot_reserve_your_listing
  #
  # validate :listing_available
  #
  # validate :check_out_before_check_in
  #
  # def duration
  #   dur = check_out - check_in
  #   dur.to_i
  # end
  #
  # def total_price
  #   listing.price.to_f*duration
  # end
  #
  # private
  #
  #  def cannot_reserve_your_listing
  #    listing = Listing.find(listing_id)
  #    if guest_id.present? && guest_id == listing.host_id
  #      errors.add(:guest_id, "you cannot reserve your own listing")
  #    end
  #  end
  #
  #  def listing_available
  #    if self.status != "accepted" && self.check_in && self.check_out && self.listing.neighborhood && !self.listing.neighborhood.neighborhood_openings(check_in, check_out).include?(self.listing)
  #      errors.add(:reservation, "listing is not available")
  #   end
  #  end
  #
  #  def check_out_before_check_in
  #    if self.status != "accepted" && self.check_in && self.check_out && check_out <= check_in
  #      errors.add(:reservation, "check_out cannot happen before or on the same day as check_in")
  #    end
  #  end

end
