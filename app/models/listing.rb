class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  validates_associated :neighborhood

  after_save :update_host_status
  after_destroy :check_host_status


  def average_review_rating
    sum = 0.0
    self.reviews.each{|r| sum = r.rating+sum }
    sum / self.reviews.count
  end

  private

    def update_host_status
      if self.host.host == false
        self.host.update(host: true)
      end
    end

    def check_host_status
      if !self.host.listings.any?
        self.host.update(host: false)
      end
    end

end
