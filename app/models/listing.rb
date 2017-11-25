class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create :set_host_true
  after_destroy :set_host_false

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def set_host_true
    host.update(host: true)
  end

  def set_host_false
    host.update(host: false) if host.listings.none?
  end
  
end