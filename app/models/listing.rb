class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :update_user_to_host
  after_destroy :update_user_to_not_host

  def update_user_to_host
  	host.update(host: true)
  end

  def is_available?(start_date, end_date)
  	reservations.all? {|res|
  		!(res.checkin..res.checkout).overlaps?(start_date..end_date)
  	}
  end

  def update_user_to_not_host
  	if Listing.all.none? {|listing|
  		listing.host_id == host_id }
  		host.update(host: false)
  	end
  end

  def average_review_rating
  	reviews.average(:rating)
  end

end
