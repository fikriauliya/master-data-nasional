class CreateCitizens < ActiveRecord::Migration
  def change
    create_table :citizens do |t|
      t.string :nik
      t.string :name
      t.string :location_of_birth
      t.string :kelurahan_id

      t.timestamps
    end
  end
end
