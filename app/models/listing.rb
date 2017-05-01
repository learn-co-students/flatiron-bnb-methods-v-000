class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :host_status_toggle 
  before_destroy :host_has_listings

  def host_status_toggle
  	self.host.host = true
  	self.host.save
  end

  def host_has_listings
  	if self.host.listings.length == 1
  		  	self.host.host = false
  	self.host.save
  	end
  end

end
