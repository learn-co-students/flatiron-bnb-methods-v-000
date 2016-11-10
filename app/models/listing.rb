class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  accepts_nested_attributes_for :host
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  before_create :user_to_host
  after_destroy :check_host_status

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def user_to_host
    self.host.update(host: true)
  end

  def check_host_status
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

end
