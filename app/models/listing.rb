class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :title, :address, :listing_type, :description, :price, :neighborhood

  after_save :make_host
  after_destroy :change_host_status

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def make_host
    host.update(host: true)
  end

  def change_host_status
    host.update(host: false) if host.listings.none?
  end

end
