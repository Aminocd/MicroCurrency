class RemoveCurrencyIdExternalKey < ActiveRecord::Migration[5.1]
  def change
    remove_column :attempted_reallocations, :currency_id_external_key
  end
end
