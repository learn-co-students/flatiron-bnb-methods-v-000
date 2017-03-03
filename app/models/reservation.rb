class Reservation < ActiveRecord::Base
	validates_presence_of :checkin, :checkout
	validate :own_listing
	validate :check_availability
	validate :checkout_after_checkin

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def duration
  	(checkout - checkin).to_i
  end

  def total_price
  	listing.price * duration
  end


  private 

		def own_listing
		  if self.guest == self.listing.host
		    errors.add(:guest, "You can't reserve your own listing.")
		  end
		end

		def check_availability
	  	listing.reservations.each do |r|
	  		dates_taken = (r.checkin..r.checkout)
	  		if dates_taken === checkin || dates_taken === checkout
	  			errors.add(:guest_id, "Unavailable.")
	  		end
	  	end
  	end

  	def checkout_after_checkin
  		if checkin && checkout && checkout <= checkin
  			errors.add(:guest_id, "Checkout must be after checkin")
  		end
  	end

end
