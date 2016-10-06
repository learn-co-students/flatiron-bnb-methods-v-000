require 'concerns/extra_reservation_info'

class Listing < ActiveRecord::Base
  include ReservationHelpers::InstanceMethods
  
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :convert_user_to_host
  after_destroy :unconvert_user

  def convert_user_to_host
  	#puts "hostname #{host.name}"
  	host.host = true
  	host.save
  	# puts "hoststatus #{host.host}"
  end

  def unconvert_user
  	if host.listings.empty?
  		host.host = false
  		host.save
  	end
  end

  def average_review_rating
  	all_reviews = self.reviews.collect{|review| review.rating}
  	all_reviews.sum.to_f / all_reviews.count.to_f
  end

  


end
  