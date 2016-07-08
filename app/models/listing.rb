class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"
  
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  
  after_save :change_user_to_host
  before_destroy :remove_host_as_host

  def average_review_rating
    reviews.average(:rating)
   # total = reviews.(:ratings).inject(0){|sum,x| sum + x }
   # len = reviews.(:ratings).length
   #  average = total.to_f / len
   #  average
  end
  


  private

   def self.available(date1, date2)
    if date1 && date2
      joins(:reservations).
        where.not(reservations: {checkin: date1..date2}) &
      joins(:reservations).
        where.not(reservations: {checkout: date1..date2})
    else
      []
    end
  end


  def change_user_to_host
    unless host.host?
      host.update(host: true)
    end
  end
  def remove_host_as_host
    # remove .id
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end


 
end
