class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  after_create :change_host_status
  after_destroy :change_host_status_back

  def average_review_rating
    #binding.pry
    reviews.average(:rating)
  end

  private

  def change_host_status
    self.host.update(host: true)
  end

  def change_host_status_back
    self.host.update(host: false) if !self.host.listings.any?
  end
end
