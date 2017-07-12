class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  
  after_create do
    self.host.update(host: true)
  end

  after_destroy do
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end


  def average_review_rating
    ratings = self.reviews.collect do |review|
      review.rating
    end
    ratings.inject {|sum, review| sum + review}.to_f / self.reviews.size
  end
end
