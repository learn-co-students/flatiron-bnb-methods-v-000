class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :title, :address, :listing_type, :description, :price, :neighborhood_id
  
  def average_review_rating
    total_score = 0
    self.reviews.each { |r| total_score += r.rating }
    total_score.to_f / self.reviews.count
  end

  after_save :turn_on_host_status
  before_destroy :turn_off_host_status

  def available?(startdate, enddate)
    self.reservations.none? do |r|
      no_go_range = r.checkin .. r.checkout
      no_go_range === startdate || no_go_range === enddate
    end
  end

  private

  def turn_on_host_status
    self.host.update(host: true)
  end

  def turn_off_host_status
    if self.host.listings.count == 1
      self.host.update(host: false)
    end
  end

end
