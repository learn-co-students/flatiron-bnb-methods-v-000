class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_save :set_host
  after_destroy :unset_host

  def set_host
    self.host.update(:host => true) if self.host
  end

  def unset_host
    if self.host && self.host.listings.length == 0
      self.host.update(:host => false)
    end
  end

  def average_review_rating
    self.reviews.average(:rating)
  end


end
