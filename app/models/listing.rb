class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_save :set_host_status
  before_destroy :remove_host_status

  def average_review_rating
    reviews.average(:rating)
  end


  private
    def set_host_status
      host.update(host: true)
    end

    def remove_host_status
      if Listing.where(host: host).where.not(id: id).empty?
        host.update(host: false)
      end
    end

end
