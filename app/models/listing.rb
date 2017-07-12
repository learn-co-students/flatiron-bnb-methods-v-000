class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations 

  has_many :joins
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  before_save :change_host_status
  before_destroy :revert_host_status

  def average_review_rating
  	number_of_reviews = 0.00
  	rating_total = 0
  	reviews.each do |review|
  		rating_total += review.rating
  		number_of_reviews += 1
  	end
  	rating_total.to_f / number_of_reviews
  end

  def change_host_status
    self.host.host = true
    self.host.save
  end

  def revert_host_status
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end


end
