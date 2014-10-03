class AddTpsIdToCitizens < ActiveRecord::Migration
  def change
    add_column :citizens, :tps_id, :integer
  end
end
