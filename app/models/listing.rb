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
  validates :host_id, presence: true

  before_create do 
  	self.host.update(host:true)
  end
  
  after_destroy :turn_host_status_to_false

  def turn_host_status_to_false
  	if self.host.listings.empty?
  		self.host.update(host: false)
  	end
  end

  def average_review_rating
  	self.reviews.inject(0) {|sum, review| sum + review.rating}.to_f / self.reviews.count
  end

  
end
