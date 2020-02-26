class AddActiveToAttemptedLinkage < ActiveRecord::Migration[5.1]
  def change
    add_column :attempted_linkages, :active, :boolean
  end
end
