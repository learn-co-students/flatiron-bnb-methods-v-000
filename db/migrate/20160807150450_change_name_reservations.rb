class ChangeNameReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :check_in, :check_in
    rename_column :reservations, :check_out, :check_out

  end
end
