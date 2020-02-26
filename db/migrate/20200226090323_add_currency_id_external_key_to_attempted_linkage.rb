class AddCurrencyIdExternalKeyToAttemptedLinkage < ActiveRecord::Migration[5.1]
  def change
    add_column :attempted_linkages, :currency_id_external_key, :integer
  end
end
