class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_host
  before_destroy :host_status

  # Finds the average rating for a listing
  def average_review_rating
    reviews.average(:rating)
  end

  def booked_dates
    reservations.collect { |res| (res.checkin..res.checkout).to_a}.flatten.uniq
  end

  private
  # Makes user a host when a listing is created
  def make_host
    unless self.host.host
      self.host.update(:host => true)
    end
  end

  # Changes host status to false when listing is destroyed and user has no more listings
  def host_status
    if self.host.listings.count <= 1
      self.host.update(:host => false)
    end
  end

  
end
