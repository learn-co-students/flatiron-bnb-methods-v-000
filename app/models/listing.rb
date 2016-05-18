class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, :presence => {message: "can't be blank"}

  before_save do
    host.update(host: true)
  end
  after_destroy do
    host.update(host: false) if host.listings.empty?
  end

  def average_review_rating
    reviews.average(:rating)
  end
  
end
