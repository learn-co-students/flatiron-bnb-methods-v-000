class Listing < ActiveRecord::Base

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  # sets User host attribute to 'true' when a listing is created
  before_create :set_host_attribute

  # if a host has no more listings, User host attribute is reset to false
  after_destroy :release_host_attribute, if: "self.host.listings.empty?"

  def average_review_rating
    reviews.average(:rating)
  end

  private
  def set_host_attribute
    host.update(host: true)
  end

  def release_host_attribute
      host.update(host: false)
  end
end

## Passes master and solution branch specs.  because of differing schema for Users table RE: host/is_host attribute, solution spec adjusted to avoid db changes
