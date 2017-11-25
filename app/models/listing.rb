class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :make_into_host
  before_destroy :turn_to_normal_user

  def average_review_rating
  	reviews.average(:rating)
  end

  private

  def make_into_host
  	unless self.host.host
  		self.host.host = true
  		self.host.save
  	end
  end

  def turn_to_normal_user
  	if self.host.listings.count <= 1
  		self.host.host = false
  		self.host.save
  	end
  end

end
