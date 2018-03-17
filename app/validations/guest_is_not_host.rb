class GuestIsNotHost < ActiveModel::Validator
  def validate(record)
    if record.listing.host == record.guest
      record.errors[:guest] << 'Host cannot be a guest.'
    end
  end
end
