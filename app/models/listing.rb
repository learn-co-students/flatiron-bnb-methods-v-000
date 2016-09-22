class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create do
    self.host.host = true
    self.host.save
  end

  before_destroy do
    if self.host.listings.size == 1
      self.host.host = false
      self.host.save
    end
  end
end
