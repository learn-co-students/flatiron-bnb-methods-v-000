class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :make_host
  before_destroy :host_status

  def average_review_rating
    numerator = 0
    denominator = self.reviews.count
    self.reviews.each do |review|
      numerator += review.rating
    end
    return numerator.to_f/denominator
  end

  private
  def make_host
    unless self.host.host
      self.host.update(host: true)
    end
  end

  def host_status
    if self.host.listings.count <=1
      self.host.update(host: false)
    end
  end
  
end
