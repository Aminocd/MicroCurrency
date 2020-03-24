class DropPlacements < ActiveRecord::Migration[5.1]
  def change
    drop_table :placements
  end
end
