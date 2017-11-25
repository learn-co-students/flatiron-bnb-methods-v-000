class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create :set_host_true
  after_destroy :set_host_false

  def host?
    self.host.host
  end

  def average_review_rating
    reviews_sum = 0

    self.reviews.each do |review|
      reviews_sum += review.rating  
    end
    reviews_sum.to_f/self.reviews.count.to_f
  end

  private 

  def set_host_true
    self.host.host = true if self.host
    self.host.save
  end

  def set_host_false
    self.host.host = false if !self.host.listings.any?
    self.host.save
  end
  
end
