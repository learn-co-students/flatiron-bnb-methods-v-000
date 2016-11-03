class Listing < ActiveRecord::Base
  include Openings
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

  after_create :make_host
  after_destroy :remove_host

  def make_host
    host.make_host
  end

  def remove_host
    host.make_guest if host.listings == []
  end

  def average_review_rating
    total_of_reviews = 0
    reviews.each do |review|
      total_of_reviews += review.rating
    end
    total_of_reviews.to_f / reviews.size
  end

end
