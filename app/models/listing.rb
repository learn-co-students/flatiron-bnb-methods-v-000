class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, 
            :title, 
            :listing_type, 
            :description, 
            :price, 
            :neighborhood_id,
             presence: true
  
  after_create do 
    self.host.update(host: true) if host
  end
 
  after_destroy do 
    self.host.update(host: false) if host.listings.empty?
  end
  
  def average_review_rating
    reservations.map {|res| (res.review.rating if res.review) || 0}.inject(0.0){|sum, el| sum + el} / reservations.size
  end
  
  def open_during?(dateRange)
    reservations.empty? || reservations.any? do |res|
        !dateRange.cover?(res.checkin) && !dateRange.cover?(res.checkout)
    end
  end
  
end