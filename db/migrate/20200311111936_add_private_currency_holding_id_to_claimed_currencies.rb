class AddPrivateCurrencyHoldingIdToClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    add_column :claimed_currencies, :private_currency_holding_id, :integer
  end
end
