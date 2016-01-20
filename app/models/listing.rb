require 'pry'
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price,
                        :neighborhood

  before_save :make_user_host
  before_destroy :remove_host_status

  def average_review_rating
    unless self.reviews.count == 0
      reviews.inject(0) { |sum, review| sum += review.rating }.to_f / self.reviews.count
    end
  end

  private

  def make_user_host
    unless self.host.host
      self.host.update(host: true)
    end
  end

  def remove_host_status
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end
end
