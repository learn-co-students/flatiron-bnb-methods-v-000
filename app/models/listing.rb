class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  before_create :make_host_status
  after_destroy :remove_host_status

  def make_host_status
    self.host.update(host: true)
  end

  def remove_host_status
    self.host.update(host: false) if self.host.listings.empty?
  end

  def average_review_rating
    avg_rating = self.reviews.map { |review| review.rating }.sum
    avg_rating.to_f / self.reviews.count.to_f
  end
end
