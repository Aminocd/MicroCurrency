class CreateAttemptedReallocations < ActiveRecord::Migration[5.1]
  def change
    create_table :attempted_reallocations do |t|
      t.references :user, foreign_key: true
      t.references :claimed_currency, foreign_key: true
      t.integer :currency_id_external_key
      t.boolean :active, default: true
      t.string :username

      t.timestamps
    end
  end
end
