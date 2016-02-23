class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :guest_not_host, :check_availability, :checkin_comes_first

	def duration
		(checkout - checkin).to_f
	end

	def total_price
		(listing.price * duration).to_f
	end

	private
		def guest_not_host
			if guest_id == listing.host_id
				errors.add(:guest_id, "You own this listing!")
			end
		end

		def check_availability
      listing.reservations.each do |res|
        taken_dates = (res.checkin..res.checkout)
        if taken_dates === checkin || taken_dates === checkout
          errors.add(:guest_id, "Unavailable.")
        end
      end
		end

		def checkin_comes_first
      if (checkin.present? && checkout.present?) && checkin >= checkout
        errors.add(:guest_id, "Check-In cannot come after Check-Out.")
			end
		end

end
