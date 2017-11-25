class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, not available right now")
      end
    end
  end

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own spot")
    end
  end

  def check_out_after_check_in
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your checkout date needs to be after your checkin")
    end
  end
end
