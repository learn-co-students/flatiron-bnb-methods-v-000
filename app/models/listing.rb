class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :title, :address, :description, :listing_type, :price, :neighborhood

  before_validation :truthy_host_status
  before_destroy :falsey_host_status

  def average_review_rating
    reviews.collect(&:rating).inject(:+) / reviews.count.to_f
  end

  protected

  def truthy_host_status
    if host.present?
      self.host.update(host: true)
    end
  end

  def falsey_host_status
    if host.listings.count <= 1
      self.host.update(host: false)
    end
  end
end
