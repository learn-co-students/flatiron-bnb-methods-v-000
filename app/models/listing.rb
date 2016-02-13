class Listing < ActiveRecord::Base
	belongs_to :neighborhood
	belongs_to :host, :class_name => "User"
	has_many :reservations
	has_many :reviews, :through => :reservations
	has_many :guests, :class_name => "User", :through => :reservations
	validates :address, presence: true
	validates :listing_type, presence: true
	validates :title, presence: true
	validates :description, presence: true
	validates :price, presence: true
	validates :neighborhood, presence: true

	before_save :change_host_status
	before_destroy :check_host_status

	def average_review_rating
		numerator = reviews.inject(0){|sum,r| sum += r.rating}
		denominator = self.reviews.count
		if denominator == 0
			"cannot divide by 0"
		else
			numerator.to_f / denominator
		end
	end

	private
		def change_host_status
			unless self.host.host
				self.host.update(host: true)
			end
		end

		def check_host_status
			if self.host.listings.count <= 1
				self.host.update(host: false)
			end
		end
  
end
