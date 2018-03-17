class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  
  before_save :make_host
  before_destroy :undo_host
  
  def average_review_rating
    ratings = reviews.collect {|review| review.rating}
    ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
  end
  
  private
  
  def make_host
    self.host.update(host: true) if self.host
  end
  
  def undo_host
    self.host.update(host: false) if self.host.listings.count == 1
  end  
end
