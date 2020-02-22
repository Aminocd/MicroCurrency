class CreateAttemptedLinkages < ActiveRecord::Migration[5.1]
  def change
    create_table :attempted_linkages do |t|
      t.references :user, foreign_key: true
      t.references :claimed_currency, foreign_key: true
      t.integer :deposit_confirmation_value

      t.timestamps
    end
  end
end
