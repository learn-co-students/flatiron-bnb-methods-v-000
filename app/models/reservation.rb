class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :available, :checkout_after_checkin, :guest_is_not_host

  def duration
  	(checkout - checkin).to_i
  end

  def total_price
  	listing.price * duration
  end

  private

	  def available
	    Reservation.where(listing_id: listing.id).where.not(id: id).each do |reservation|
	      booked_dates = reservation.checkin..reservation.checkout
	      if booked_dates === checkin || booked_dates === checkout
	        errors.add(:guest_id, "This lodging is not available during your requested date range.")
	      end
	    end
	  end

	  def checkout_after_checkin
	  	if checkout && checkin && checkout <= checkin
	  		errors.add(:guest_id, "The check-in date must precede the check-out date.")
	  	end
	  end

	  def guest_is_not_host
	  	if guest_id == listing.host_id
	  		errors.add(:guest_id, "You cannot reserve your own dwelling.")
	  	end
	  end

end
