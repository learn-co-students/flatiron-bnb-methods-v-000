class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :set_host
  after_destroy :set_host

  def average_review_rating
      self.reviews.sum(:rating)/self.reviews.count.to_f
  end

  def set_host
      if self.host.listings.empty?
          self.host.host = false
      else
          self.host.host = true
      end
      self.host.save
  end

  def reserved?(start_date, end_date)
      !self.reservations.select { |r| r.dates.include?(Date.parse(start_date)) || r.dates.include?(Date.parse(end_date)) }.empty?
  end
end
