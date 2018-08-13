class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_save :set_host_true
  after_destroy :set_host_false

  include ArelTables
  extend ArelTables

  def self.reservation_count
    sum = 0
    all.each {|listing| sum += listing.reservations.count}
    sum
  end

  def average_review_rating
    (self.reviews.sum(:rating).to_f)/(self.reviews.count)
  end

  private

  def set_host_true
    self.host.host = true if !self.host.host?
    self.host.save
  end

  def set_host_false
    self.host.host = false if !Listing.find_by(host: self.host)
    self.host.save
  end
  
end