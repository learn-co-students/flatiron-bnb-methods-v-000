class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, presence: true 
  validates :neighborhood, presence: true
  before_save :change_host_status
  before_destroy :change_host_false

	
	def average_review_rating
		ratings_sum = 0
		self.reviews.each do |review|
			ratings_sum += review.rating
		end 
		ratings_sum.to_f / self.reviews.length 
	end

	private

	def change_host_status
	 	self.host.host = true
	 	self.host.save
	end 

	def change_host_false
		if self.host.listings.length == 1
			self.host.host = false 
			self.host.save
		end 
	end


end
