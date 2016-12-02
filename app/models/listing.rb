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

  before_save :change_host_status
  def change_host_status
    self.host.update(host: true)
  end

  before_destroy :make_host_false
  def make_host_false
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end

  def average_review_rating
    rating_sum = 0
    reviews.each do |review|
      rating_sum += review.rating.to_i
    end
    average = rating_sum.to_f/reviews.count.to_f
  end


end
