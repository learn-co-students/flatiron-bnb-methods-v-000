module ArelTables
  def cities_arel
    City.arel_table
  end

  def listings_arel
    Listing.arel_table
  end

  def neighborhoods_arel
    Neighborhood.arel_table
  end

  def reservations_arel
    Reservation.arel_table
  end

  def users_arel
    User.arel_table
  end
end