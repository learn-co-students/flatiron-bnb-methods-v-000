class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :change_host_status
  after_destroy :check_host_status
  def change_host_status
    host.host = true
    host.save
  end

  def check_host_status
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    all_ratings = []
    self.reviews.each do |review|
      all_ratings << review.rating
    end
    all_ratings.sum/all_ratings.count.to_d
  end

  def available?(date)
    reservations.none? do |res| 
      if date > res.checkin
        date < res.checkout
      else
        false
      end
    end
  end
end
