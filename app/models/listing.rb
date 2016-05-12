require 'pry'

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create :set_host_to_true
  after_destroy :set_host_to_false

  def set_host_to_true
    self.host.host = true
    self.host.save
  end

  def set_host_to_false
    self.host.host = false if !self.host.listings.any?
    self.host.save
  end

  def average_review_rating
    sum = 0
    self.reservations.each do |reservation|
      sum += reservation.review.rating.to_f 
    end
    sum / self.reservations.size
  end
end
