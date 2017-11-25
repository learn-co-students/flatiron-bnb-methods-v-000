class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_host
  before_destroy :remove_host

  def average_review_rating
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    total.to_f / self.reviews.count
  end

  private

  def make_host
    self.host.update(host: true)
    self.host.save
  end
  
  def remove_host
    if self.host.listings.count == 1
      self.host.update(host: false)
      self.host.save
    end
  end

end
