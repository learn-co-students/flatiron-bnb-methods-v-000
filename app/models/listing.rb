class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :convert_user_to_host
  before_save

  def :convert_user_to_host
  	host.host = true
  end

  def :unconvert_user
  	if host.empty?
  		host.host = false
  	end
  end

  def all_reviews_for_listing
  	all_reviews = []
  	self.reservations.all do |reservation|
  		all_reviews << reservation.reviews
  	end
  	all_reviews.flatten.compact!
  end

  def averate_review_rating
  	all_ratings = []
  	self.all_reviews_for_listing.each do |review|
  		all_ratings << review.rating
  	end
  	all_ratings.sum.to_f / all_ratings.count.to_f
  end
  
end
