class Listing < ActiveRecord::Base
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_save :set_host
  before_destroy :remove_host

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def average_review_rating
    self.reviews.map { |rev| rev.rating }.reduce(:+).to_f / self.reviews.count
  end

  private

  def set_host
    unless host.host?
      host.update(host: true)
    end
  end

  def remove_host
    if host.listings.count <= 1
      host.update(host: false)
    end
  end
  
end
