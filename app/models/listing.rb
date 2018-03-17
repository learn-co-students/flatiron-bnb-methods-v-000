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

  after_create :change_host
  after_destroy :change_host

  def available?(checkin, checkout)
  	unless self.reservations.any? { |r| checkin.to_date.between?(r.checkin, r.checkout) || checkout.to_date.between?(r.checkin, r.checkout)} 
  		true
  	end
  end

  def change_host
  	if self.host.listings.empty?
  		self.host.update(host: false)
  	else
  		self.host.update(host: true)
  	end
  end

  def average_review_rating
  	total_reviews = self.reviews.count
  	total_count = 0
  	self.reviews.each do |r|
  		total_count += r.rating
  	end
  	total_count.to_f / total_reviews
  end

end
