class Reservation < ActiveRecord::Base

	validates :checkin, presence: true
	validates :checkout, presence: true
	validate :checkin_available
	validate :checkout_available
	validate :checkin_before_checkout
	validate :checkin_checkout_not_same

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def total_price
  	self.listing.price*self.duration
  end

  def duration
  	Date.parse(self.checkout.to_s)-Date.parse(self.checkin.to_s)
  end

  private

  	def checkin_checkout_not_same
			if valid_date?(checkin.to_s) && valid_date?(checkout.to_s)
				if Date.parse(checkin.to_s)==Date.parse(checkout.to_s)
					errors.add(:checkin, "Check-in same as Check-out date")
				end
			else
				errors.add(:checkin, "Invalid date(s)")
			end
  	end

  	def checkin_before_checkout
  		if valid_date?(checkin.to_s) && valid_date?(checkout.to_s)
  			if Date.parse(checkin.to_s)>Date.parse(checkout.to_s)
  				errors.add(:checkin, "Check-in before Check-out date")
  			end
  		else
  			errors.add(:checkin, "Invalid date(s)")
  		end
  	end

  	def checkin_available
  		if valid_date?(checkin)

  			checkin_date=Date.parse(checkin.to_s)
  			if self.listing.in_middle_of_reservation?(checkin_date)
      		errors.add(:checkin, "unavailable")
  			end

  		else
  			errors.add(:checkin, "is not a valid date")
  		end
  	end

  	def checkout_available
  		if valid_date?(checkout)

  			checkout_date=Date.parse(checkout.to_s)
  			if self.listing.in_middle_of_reservation?(checkout_date)
      		errors.add(:checkout, "unavailable")
  			end

  		else
  			errors.add(:checkout, "is not a valid date")
  		end
  	end

		def valid_date?(date)
			begin
				Date.parse(date.to_s)
			rescue
				false
			else
				true
			end
		end


end
