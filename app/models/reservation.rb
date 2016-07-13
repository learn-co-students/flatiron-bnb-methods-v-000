class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
	
	validates :checkin, presence: true
	validates :checkout, presence: true
	
	validate :self_reserve, :available, :check_timing
	
	def duration
		(self.checkout - self.checkin).to_i
	end
	
	def total_price
		self.listing.price * duration
	end
	
	private
	
	def self_reserve
		if self.guest == self.listing.host
			errors.add(:guest_id, "You can't be the host")
		end
	end
	
	def available
		unless self.listing.available?(checkin, checkout)
			errors.add(:base, 'No listing available')
		end
	end
	
	def check_timing
		if self.checkin && self.checkout && self.checkin >= self.checkout
			errors.add(:checkin, "Can't be later than check out")
		end
	end
end
