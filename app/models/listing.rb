class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_create :set_host
  after_destroy :unset_host

  def average_review_rating
    sum = 0.0
    if self.reviews.count == 0
      0
    else
      self.reviews.each {|review| sum += review.rating}
      sum / self.reviews.count
    end
  end
  
  private

  def set_host
    host1 = self.host
    host1.host = true
    host1.save
  end

  def unset_host
    host1 = self.host
    if host1.listings.count == 0 #if this user has no listing left
      host1.host = false
      host1.save
    end
  end



end
