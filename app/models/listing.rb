class Listing < ActiveRecord::Base

  include Measurable::InstanceMethods

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  # when listing created changes user host status
  after_save :turn_on_host_status

  # when all of a host's listings are destroyed changes host status to false
  before_destroy :turn_off_host_status

  def turn_on_host_status
    self.host.update(host: true)
  end

  def turn_off_host_status
    self.host.update(host: false) if self.host.listings.count == 1
  end

  # knows its average ratings from its reviews
  def average_review_rating
    ratings = self.reviews.collect { |review| review.rating }
    ratings.inject{ |sum, rating| sum + rating }.to_f / ratings.size
  end

end
