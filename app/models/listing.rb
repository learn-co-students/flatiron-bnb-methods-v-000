class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create do |listing|
  	self.host.update(host: true)
  end
  	
  after_destroy do |listing|
  	self.host.update(host: false) if !self.host.listings.any?
  end	

  def average_review_rating
  	reviews.average(:rating)
  end 
end
