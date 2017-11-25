class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :update_host
  before_destroy :unhost

  def update_host
    self.host.update(host: true)
  end

  def unhost
    if self.host.listings.length <= 1
      self.host.update(host: false)
    end
  end

  def average_review_rating
    sum = 0 
    self.reviews.each {|r| sum += r.rating}
    sum / self.reviews.length.to_f
  end
  
end
