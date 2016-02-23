class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  before_create :update_host_status
  before_destroy :verify_update_status

  def average_review_rating
    total = reviews.inject(0) { |sum, x| sum + x.rating}
    total.to_f / reviews.length unless reviews.length == 0
  end

  private

  def update_host_status
    host.update(host: true) unless host.host
  end

  def verify_update_status
    host.update(host: false) unless host.listings.length > 1
  end

end
