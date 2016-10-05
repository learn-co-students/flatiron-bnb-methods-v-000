class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  validates :address, :title, :description, :price, :listing_type, :neighborhood, presence: true

  after_save :set_to_true
  before_destroy :keep_status_or_change_to_false

  def average_review_rating
     reviews.average(:rating)
  end
  
  private
      def set_to_true
        if host[:host] == false
          host[:host] = true
          host.save
        end
      end

      def keep_status_or_change_to_false
        if Listing.where(host: host).where.not(id: id).empty?
          host.update(host: false)
        end
      end
  end
