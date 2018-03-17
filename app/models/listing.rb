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
  validates :neighborhood, presence: true

  before_save :make_host
  before_destroy :host_status

  def average_review_rating
    if self.reviews.size > 0
      ratings_array = self.reviews.collect{ |review| review.rating }
      sum = 0.0
      ratings_array.each { |i| sum += i }
      sum / ratings_array.size
    else
      0
    end
  end

  private
  # Makes user a host when a listing is created
  def make_host
    unless self.host.host
      self.host.update(host: true)
    end
  end

  # Changes host status to false when listing is destroyed and user has no listings
  def host_status
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end

end