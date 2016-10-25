class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :make_host
  before_destroy :change_host

  def average_review_rating
    reviews.average(:rating)
  end


  def change_host
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end


  def make_host
    unless self.host.host
      host.update(host: true)
    end
  end
end
