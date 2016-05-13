class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_create :make_user_host
  after_destroy :remove_user_as_host

  def average_review_rating
    total = self.reviews.map {|r| r.rating}.sum
    total.to_f / self.reviews.count.to_f
  end

  private
    def make_user_host
      self.host.update(host: true)
    end

    def remove_user_as_host
      self.host.update(host: false) if self.host.listings.empty?
    end
end
