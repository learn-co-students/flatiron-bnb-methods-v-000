class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  #VALIDATIONS
  validates :address, presence: true, allow_blank: false
  validates :listing_type, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :price, presence: true, allow_blank: false
  validates :neighborhood, presence: true, allow_blank: false

  after_create :change_host_true
  after_destroy :change_host_false

  def average_review_rating
    x = []
    reviews.each do |r| 
    x << r.rating
    end
    x.sum / x.size.to_f
  end

  private

  def change_host_true
    host = self.host 
    host.update(host: true)
  end

  def change_host_false
    host = self.host
    if host.listings.count == 0
      host.update(host: false)
    end
  end



  
end #ends class
