class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :title, :address, :listing_type, :description, :price, :neighborhood

  before_save :change_host_status
  before_destroy :destroy_host

  def average_review_rating
    reviews.collect(&:rating).inject(:+).to_f / reviews.count
  end

  protected

  def change_host_status
    if self.host.present?
      host.update(host: true)
    end
  end

  def destroy_host
    if self.host.listings.size <= 1
      host.update(host: false)
    end
  end
end
