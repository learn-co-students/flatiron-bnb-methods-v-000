class Listing < ActiveRecord::Base
  validates_presence_of :listing_type, :address, :title, :description, :price, :neighborhood_id
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  before_save :change_status_to_true
  after_destroy :change_status_to_false

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

    def change_status_to_true
        host = self.host
        host.update(host: true)
    end

    def change_status_to_false
      if self.host.listings.empty?
        self.host.update(host: false)
      end
    end

end
