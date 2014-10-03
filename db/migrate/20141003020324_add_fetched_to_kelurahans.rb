class AddFetchedToKelurahans < ActiveRecord::Migration
  def change
    add_column :kelurahans, :fetched, :boolean, default: false
  end
end
