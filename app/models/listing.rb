class Listing < ActiveRecord::Base

	before_save :host_save
	before_destroy :host_destroy

	validates :address, presence: true
	validates :listing_type, presence: true
	validates :title, presence: true
	validates :description, presence: true
	validates :price, presence: true
	validates :neighborhood_id, presence: true


  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  def average_review_rating
  	review_total=self.reviews.inject(0) {|sum, r| sum+=r.rating}
  	review_count=self.reviews.count
  	review_total.to_f/review_count.to_f
  end

  def available?(from:, to:) 	
  	from=Date.parse(from.to_s)
  	to=Date.parse(to.to_s)
  	self.reservations.none? do |r|
	  	check_in = Date.parse(r.checkin.to_s)
	  	check_out = Date.parse(r.checkout.to_s)
	  	check_in.between?(from, to) || check_out.between?(from, to)
	  end
  end

  def in_middle_of_reservation?(date) 	
	  	self.reservations.any? do |r|
		  	check_in = Date.parse(r.checkin.to_s)
		  	check_out = Date.parse(r.checkout.to_s)
		  	date.between?(check_in, check_out)
		  end
  end

  private
  	def host_save
  		self.host.update(host:true) unless self.host.host
  	end

  	def host_destroy
  		self.host.update(host:false) if (self.host.listings.count < 2)
  	end

end
