class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :host_status
  after_destroy :host_status

  def host_status
    if host.listings.empty?
      host.update(host: false)
    else
      host.update(host: true)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
