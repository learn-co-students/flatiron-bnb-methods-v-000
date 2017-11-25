class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  after_save :set_host_status
  before_destroy :delete_host_status

  validates_presence_of :title, :address, :listing_type, :description, :price, :neighborhood_id

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

    def set_host_status
      host.update(host:true)
    end

  def delete_host_status
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end
  
end
