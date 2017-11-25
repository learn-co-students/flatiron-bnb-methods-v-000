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
  validates :neighborhood_id, presence: true

	before_save :make_host_true
	after_destroy :make_host_false

	def make_host_true
  	self.host.host = true
  	self.host.save
  end

  def make_host_false
  	@this_host = self.host
  	if @this_host.listings.size == 0 
  		self.host.host = false
  		self.host.save
		end
	end

	def average_review_rating
		ratings = []
		self.reviews.each do |r|	
			ratings << r.rating
		end
		ratings_sum = ratings.inject(:+)
		ratings_sum/(self.reviews.count.to_f)
	end


end
