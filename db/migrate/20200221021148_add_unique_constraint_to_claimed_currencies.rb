class AddUniqueConstraintToClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    add_index :claimed_currencies, :currency_id_external_key, unique: true
  end
end
