class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  has_many :reviews

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  validates_existance_of :neighborhood

  before_save :make_host
  before_destroy :host_status

  # Finds the average rating for a listing
  def average_rating
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    average = total.to_f / ratings.count
  end

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
