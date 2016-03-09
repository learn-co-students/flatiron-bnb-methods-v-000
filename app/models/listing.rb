class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :create_host
  after_destroy :remove_host

  def average_review_rating
    reviews.average(:rating)
  end

  def create_host
    self.host.update(host: true)
  end

  def remove_host
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

end
