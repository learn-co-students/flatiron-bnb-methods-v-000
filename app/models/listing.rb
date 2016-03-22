class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :make_user_a_host
  after_destroy :remove_host_status

  def average_review_rating
    total = self.reviews.map {|r| r.rating}.sum
    total.to_f / self.reviews.count.to_f
  end
  
  private
    def make_user_a_host
      self.host.update(host: true)
    end

    def remove_host_status
      self.host.update(host: false) if self.host.listings.empty?
    end
end
