class RenamePrivateCurrencyHoldingsIdToPrivateCurrencyHoldingsIdExternalKey < ActiveRecord::Migration[5.1]
  def change
    rename_column :claimed_currencies, :private_currency_holding_id, :private_currency_holding_id_external_key
  end
end
