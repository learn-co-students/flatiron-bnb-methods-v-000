class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :host_status_true
  after_destroy :change_host_false

  # knows its average ratings from its reviews
 	def average_review_rating
 		reviews.average(:rating)
 	end

  private

  # when listing created
  #   changes user host status
  # when some of a host's listings are destroyed
  #   does not change the host status to false
  def host_status_true
  	host.update(host: true)
  end

  # when all of a host's listings are destroyed
  # 	changes host status to false
  def change_host_false
  	if host.listings.none?
  		host.update(host: false)
  	end
  end
  
end
