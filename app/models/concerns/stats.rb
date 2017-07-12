module Stats
  def res_to_listings
    all.reject { |n| n.reservations.empty? || n.listings.empty? }.max_by {|n| (n.reservations.count / n.listings.count) }
  end

  def open?(cin,cout) #open listings
    cin = cin.to_date; cout = cout.to_date
    Listing.all.reject { |list| list.reservations.any? {|res| res.checkin.between?(cin, cout) || res.checkout.between?(cin, cout) }}
  end
end
