class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, through: :reservations, :class_name => "User"

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :add_host_status
  after_destroy :remove_host_status

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def add_host_status
    self.host.update(host: true)
  end

  def remove_host_status
    self.host.update(host: false) if host.listings.empty?
  end
end
