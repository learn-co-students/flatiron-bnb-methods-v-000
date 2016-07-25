class Listing < ActiveRecord::Base
  validates_presence_of :listing_type, :address, :title, :description, :price, :neighborhood_id
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  before_save :make_host
  before_destroy :host_status


  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def make_host
    h = self.host
    h.update(host:true)
  end

  def host_status
  self.host.update(:host => false) if self.host.listings.count <= 1
  end
end
