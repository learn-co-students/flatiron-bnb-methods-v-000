class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
  	guest_arr = []
  	self.listings.each do |listing|
  		listing.reservations.each do |res|
  			guest_arr << User.find(res.guest_id)
  		end
  	end
  	guest_arr.uniq
  end

  def hosts
  	self.reviews.collect do |rev|
  		User.find(rev.reservation.listing.host_id)
  	end
  end

  def host_reviews
  	rev_arr = []
  	self.listings.each do |listing|
  		listing.reservations.each do |res|
  			# binding.pry
  			rev_arr << res.review
  		end
  	end
  	rev_arr.uniq
  end

end
