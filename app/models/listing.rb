class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood
  
  after_create :host_true
  after_destroy :host_false

  def average_review_rating
    reviews.average(:rating)
  end


  private

  def host_true
    self.host.update(host: true)
  end

  def host_false
      self.host.update(host: false) if self.host.listings.count == 0
  end
  
end
