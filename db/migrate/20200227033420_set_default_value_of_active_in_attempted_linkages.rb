class SetDefaultValueOfActiveInAttemptedLinkages < ActiveRecord::Migration[5.1]
  def change
    change_column :attempted_linkages, :active, :boolean, default: true
  end
end
