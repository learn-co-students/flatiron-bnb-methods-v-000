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

  after_create :change_host_value
  after_destroy :delete_host

  def average_review_rating
    number_of_reviews = self.reviews.length
    review_total = 0 
    reviews.each do |review|
      review_total += review.rating 
    end 
    average_review = review_total.fdiv(number_of_reviews)
    average_review
  end 

  private 

  def change_host_value
    self.host.host = true
    self.host.save
  end

  def delete_host
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end 
  end 
  
end
