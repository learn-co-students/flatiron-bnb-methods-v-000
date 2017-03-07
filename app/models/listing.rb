class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create :toggle_host
  after_destroy :remove_host


  def average_review_rating
    sum = 0.0
    reviews.each do |review|
      sum += review.rating
    end
    sum/reviews.length
  end

  private

  def toggle_host
    host.host = true
    host.save
  end

  def remove_host
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

end
