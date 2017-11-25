class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title,
        :description, :price, :neighborhood_id, :host_id

  after_save :host_status
  after_destroy :delete_host_status

  def host_status
    host.update(host: true)
  end

  def delete_host_status
    if Listing.where(host_id: self.host.id).empty?
      self.host.update(host: false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
