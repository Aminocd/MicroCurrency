class AddCurrencyNameToClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    add_column :claimed_currencies, :currency_name, :string
  end
end
