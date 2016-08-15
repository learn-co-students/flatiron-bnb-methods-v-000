class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  after_create :true_host

  def true_host
    self.host.host = true
  end

  def available?(checkin, checkout)
    if self.reservations.any? {|x| checkin.to_date.between?(x.checkin, x.checkout) || checkout.to_date.between?(x.checkin, x.checkout)}
      false
    else
      true
    end
  end

  def availabilities(checkin, checkout)
    array = []
    self.reservations.each do |x|
      if checkin.to_date.between?(x.checkin, x.checkout) || checkout.to_date.between?(x.checkin, x.checkout)
      else
        array << x
      end
    end
    array
  end
  
end
