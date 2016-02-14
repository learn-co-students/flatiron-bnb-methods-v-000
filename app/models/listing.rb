class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :host_status

  after_destroy :false_if_empty

  def host_status
    self.host.host = true
    self.host.save
  end

  def false_if_empty
    if self.host.listings.empty?
      self.host.host = false
      self.host.save 
    end
  end

  def average_review_rating
    rating_array = self.reviews.map {|review| review.rating}
    total = rating_array.reduce(:+).to_f
    count = rating_array.count.to_f
    total / count
  end


end
