class Listing < ActiveRecord::Base
  after_create :make_host
  before_destroy :remove_host

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
  
  def make_host
    User.find(self.host_id).update(host: true) 
  end

  def remove_host
    if Listing.where(host_id: self.host_id).count == 1
      User.find(self.host_id).update(host: false)
    end
  end

  def average_review_rating
    ratings_array = self.reviews.map {|review| review.rating}
    ratings_array.inject(0.0) { |sum, el| sum + el }.to_f / ratings_array.size
  end

end