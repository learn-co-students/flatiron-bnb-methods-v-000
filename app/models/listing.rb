class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_create :host_is_host
  after_destroy :host_is_not_host

  def host_is_host
    host = User.find(host_id)
    host.host = true
    host.save
  end

  def host_is_not_host
    host = User.find(host_id)
    if host.listings == []
      host.host = false
      host.save
    end
  end

  def average_review_rating
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    return total.to_f/self.reviews.count
  end

end
