class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, :address, :listing_type, :description, :price, :neighborhood_id, :host_id, presence: true

  before_create :make_host
  before_destroy :remove_host

  private

  def make_host

  end

  def remove_host
    self.host.host = false
  end
end
