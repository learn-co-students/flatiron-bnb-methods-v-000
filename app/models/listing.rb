class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_save :change_host_status
  after_destroy :does_host_have_any_listings

  def average_review_rating
    sum = 0
    reviews = 0
    self.reviews.each do |review|
      sum += review.rating
      reviews += 1
    end
    average = sum.to_f / reviews.to_f
  end

  private

  def change_host_status
    self.host.update(host: true) unless self.host.host == true
  end

  def does_host_have_any_listings
    if self.host.listings.count == 0
      self.host.update(host: false)
    end
  end

end
